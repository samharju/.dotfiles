local Chat = require("samharju.cospaget.chat")
local log = require("samharju.cospaget.dev").log

vim.g.cospaget_debug = false

---@class Message
---@field role string
---@field content string
---
---@class SessionOpts
---@field host string
---@field model string
---@field save boolean
---@field session_storage string

---@class SessionInstance
---@field options SessionOpts
---@field ongoing_process vim.SystemObj?
---@field messages table<Message>
---@field filename string
---@field title string
---@field new fun(self:SessionInstance,opts?:SessionOpts):SessionInstance
---@field start fun(self:SessionInstance)
---@field post fun(self:SessionInstance, body:table, chat:ChatInstance)
---@field save fun(self:SessionInstance)
---@field load fun(opts?:SessionOpts)
---@field tools table

local tooldefs = {}
for _, v in pairs(require("samharju.cospaget.tools")) do
    table.insert(tooldefs, v.schema)
end

---@type SessionInstance
local Session = {
    options = {
        host = "http://localhost:11434",
        model = "mistral:7b",
        -- model = "llama3.2:latest",
        save = false,
        session_storage = vim.fn.fnamemodify("~/.cache/nvim/cospaget/", ":p"),
    },
}

function Session:new(opts)
    log("session new")
    vim.fn.mkdir(self.options.session_storage, "p")
    local session = setmetatable({
        filename = string.format("cospaget-%s", os.time()),
        title = "",
        ongoing = nil,
        messages = {},
    }, { __index = Session })
    if opts then session.options = vim.tbl_extend("force", session.options, opts) end
    return session
end

function Session:save()
    log("session save")
    local body = {
        stream = false,
        model = self.options.model,
        prompt = string.format("Give a short, oneline title to this conversation without wrapping quotes:\n%s", vim.inspect(self.messages)),
    }
    if self.title == "" then
        vim.system({
            "curl",
            "-X",
            "POST",
            "-v",
            "--no-buffer",
            self.options.host .. "/api/generate",
            "-d",
            vim.json.encode(body),
        }, { text = true }, function(out)
            local data = vim.json.decode(out.stdout)
            self.title = data.response
            self:save()
        end)
        return
    end
    local fname = vim.fn.fnameescape(self.options.session_storage .. self.filename)
    local w = io.open(fname, "w")
    if w == nil then
        vim.notify("failed to open session file", fname)
        return
    end
    local dump = {
        title = self.title,
        model = self.options.model,
        messages = self.messages,
    }
    local str = vim.json.encode(dump)
    w:write(str)
    w:close()
end

function Session.load(opts)
    log("session load")
    local history = {}
    for f, _ in vim.fs.dir(Session.options.session_storage) do
        local fname = Session.options.session_storage .. f
        local fh = io.open(fname, "r")
        if fh == nil then
            vim.notify("failed to open session file", fname)
            return
        end
        local raw = fh:read("*a")
        fh:close()
        local state = vim.json.decode(raw)
        state.filename = fname
        table.insert(history, state)
    end

    vim.ui.select(history, { format_item = function(item) return item.title end }, function(item, _)
        if item == nil then return end

        local ses = Session:new(opts)
        ses.filename = vim.fn.fnamemodify(item.filename, ":t")
        ses.title = item.title
        ses.messages = item.messages
        ses.options.model = item.model
        log("loaded session:")
        log(ses)

        ses:start()
    end)
end

function Session:start()
    log("session start")
    log(self.title)
    local c = Chat:new(self.title)
    if #self.messages > 0 then
        for _, m in ipairs(self.messages) do
            if m.role == "user" then
                c:insert(m.content)
                c:insert_separator()
            elseif m.role == "assistant" then
                c:insert(string.format("# %s\n", self.options.model))
                c:insert(m.content)
                c:insert_separator(true)
            end
        end
        c:step()
    end
    c:use_callback(function(chat)
        local m = { role = "user", content = chat.prompt }
        table.insert(self.messages, m)
        chat:insert_separator()
        self:post({
            model = self.options.model,
            messages = self.messages,
            -- tools = tooldefs,
            -- options = { temperature = 0.25, top_k = 10 },
        }, chat)
    end)
end

function Session:post(body, chat)
    log("session post")
    local content = nil
    local role = nil
    vim.g.model_churning = true
    local partial_json = nil
    if self.ongoing_process ~= nil then self.ongoing_process:kill(9) end
    log(vim.json.encode(body))
    self.ongoing_process = vim.system(
        { "curl", "-X", "POST", "-v", "--no-buffer", self.options.host .. "/api/chat", "-d", vim.json.encode(body) },
        {
            text = true,
            stdout = function(_, data)
                if data == nil then return end
                vim.schedule(function()
                    local ok, d = pcall(vim.json.decode, data)
                    if not ok then
                        if partial_json == nil then
                            partial_json = data
                            return
                        else
                            ok, d = pcall(vim.json.decode, partial_json .. data)
                            if not ok then
                                partial_json = nil
                                return
                            end
                        end
                    end
                    if d.error ~= nil then
                        chat:insert(d.error)
                    else
                        if not role then role = d.message.role end
                        if d.message.tool_calls then
                            log(d)
                            table.insert(self.messages, d.message)
                            for _, v in ipairs(d.message.tool_calls) do
                                log(v)
                                local fn = v["function"].name
                                local params = v["function"].arguments

                                chat:insert(string.format("# %s\n", d.model))
                                chat:insert(fn)
                                chat:insert(vim.inspect(params))
                                local res = require("samharju.cospaget.tools")[fn].callback(params)
                                log(res)

                                local m = {
                                    role = "tool",
                                    content = res,
                                    tool_name = fn,
                                }
                                table.insert(self.messages, m)
                                self:post(body, chat)
                                return
                            end
                        end
                        if d.message.content ~= nil then
                            if not content then
                                content = d.message.content
                                -- print model on response start
                                chat:insert(string.format("# %s\n", d.model))
                            else
                                -- accumulate content to memory
                                content = content .. d.message.content
                            end
                            -- keep the tokens flowing
                            chat:insert_partial(d.message.content)
                        end
                    end
                    if d.done then
                        log(d)
                        self.ongoing_process = nil
                        vim.g.model_churning = nil

                        -- update session message buffer
                        local m = { role = role, content = content }
                        table.insert(self.messages, m)
                        log(m)

                        chat:insert_separator(true)
                        chat:step()
                        if self.options.save then self:save() end
                    end
                end)
            end,
        }
    )
end
return Session
