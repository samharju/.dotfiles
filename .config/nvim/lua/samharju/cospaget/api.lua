local replace_placeholders = require("samharju.cospaget.placeholders").replace_placeholders
local M = {
    host = "http://localhost:11434",
    model = nil,
    keep_alive = "5m",
    params = { temperature = 0.25, top_k = 10 },
    show_thinking = true,
    system = "",
    prompt = "center",
    last_prompt_file = "/tmp/nvim_cospaget_last_prompt",
    last_response = "/tmp/nvim_cospaget",
}

local ns = vim.api.nvim_create_namespace("cospaget")

local state = {
    chat_win = -1,
    chat_buf = nil,

    origin_buf = -1,
    origin_win = -1,
    output_buf = -1,
    editable = false,

    ongoing = nil,
    payload = nil,
    done = nil,
}

local logfile = vim.fn.stdpath("cache") .. "/cospaget.log"

local function log(...)
    local w = io.open(logfile, "a")
    if w == nil then
        vim.notify_once("dotfile logging failed", vim.log.levels.ERROR)
        return
    end

    local args = { ... }
    for index, value in ipairs(args) do
        if type(value) == "table" then
            args[index] = vim.inspect(value)
        else
            args[index] = tostring(value)
        end
    end

    local msg = table.concat(args, " ")

    local s = debug.getinfo(2, "Sl")
    local file = s.source:match("lua/(.*.lua)$")
    local line = s.currentline

    w:write(string.format("[%s] %s:%s: %s\n", os.date(), file, line, msg))
    w:close()
end

local function open_buf(ftype)
    if vim.api.nvim_buf_is_valid(state.output_buf) then
        vim.api.nvim_set_option_value("modifiable", true, { buf = state.output_buf })
        vim.api.nvim_buf_set_text(state.output_buf, 0, 0, -1, -1, {})
        if state.done ~= nil then vim.api.nvim_buf_clear_namespace(state.output_buf, ns, 0, -1) end
    else
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t") == "cospaget" then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
        state.output_buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(state.output_buf, "cospaget")
    end

    if ftype ~= nil then
        vim.api.nvim_set_option_value("filetype", ftype, { buf = state.output_buf })
    elseif state.origin_buf ~= -1 then
        vim.api.nvim_set_option_value("filetype", vim.bo[state.origin_buf].filetype, { buf = state.output_buf })
    end
    vim.api.nvim_set_option_value("modifiable", true, { buf = state.output_buf })
    vim.diagnostic.enable(false, { bufnr = state.output_buf })

    vim.keymap.set("n", "q", function()
        if state.ongoing ~= nil then state.ongoing:kill(9) end
        vim.api.nvim_buf_delete(state.output_buf, { force = true })
    end, { buffer = state.output_buf })

    vim.keymap.set("n", "<c-f>", function()
        if state.ongoing ~= nil then state.ongoing:kill(9) end
        vim.api.nvim_set_option_value("modifiable", true, { buf = state.output_buf })
        vim.api.nvim_buf_set_text(state.output_buf, 0, 0, -1, -1, {})
        if state.done ~= nil then vim.api.nvim_buf_clear_namespace(state.output_buf, ns, 0, -1) end
        M.post({ body = state.payload })
    end, { buffer = state.output_buf })

    vim.keymap.set("n", "<esc>", function()
        if state.ongoing ~= nil then
            state.ongoing:kill(9)
            state.done =
                vim.api.nvim_buf_set_extmark(state.output_buf, ns, 0, 0, { virt_text = { { "✕ stopped", "Error" } } })
            state.ongoing = nil
        end
    end, { buffer = state.output_buf })

    vim.keymap.set("v", "<leader>l", function()
        if not vim.api.nvim_buf_is_valid(state.output_buf) then return end

        vim.cmd.normal("!<Esc>")
        local start = vim.fn.getpos("'<")
        local finish = vim.fn.getpos("'>")
        local lines = vim.api.nvim_buf_get_lines(state.output_buf, start[2], finish[2], false)
        log("lines")
        log(lines)

        local opos = vim.api.nvim_win_get_cursor(state.origin_win)

        vim.api.nvim_buf_set_lines(state.origin_buf, opos[1], opos[1], false, lines)
    end, { buffer = state.output_buf })
end

function M.insert_text(text) vim.api.nvim_buf_set_text(state.output_buf, -1, -1, -1, -1, text) end

local function winopts(win)
    vim.api.nvim_set_option_value("wrap", true, { win = win })
    vim.cmd.stopinsert()
end

local function open_split(title)
    vim.api.nvim_buf_set_text(state.output_buf, 0, 0, -1, -1, { title, "" })
    if vim.api.nvim_win_is_valid(state.chat_win) then return end
    vim.cmd.vsplit()
    state.chat_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_buf(state.output_buf)
    winopts(state.chat_win)
end

local function thinking_hl()
    local s = -1
    local e = -1
    for i, line in ipairs(vim.api.nvim_buf_get_lines(state.output_buf, 0, -1, false)) do
        if line:match("<think>") then s = i - 1 end
        if line:match("</think>") then e = i end
    end

    if s ~= -1 and e ~= -1 then
        vim.highlight.range(state.output_buf, ns, "Comment", { s, 0 }, { e, 0 })
        vim.api.nvim_win_set_cursor(state.chat_win, { e + 3, 0 })
        if vim.api.nvim_get_current_win() == state.chat_win then vim.fn.feedkeys("z\r") end
    end
end

function M.wake(model)
    if state.ongoing then return end
    vim.notify("prewarming cospaget")

    state.payload = {
        model = model or M.model,
        prompt = "",
        keep_alive = M.keep_alive,
    }

    vim.system(
        { "curl", "-X", "POST", "-v", "--no-buffer", M.host .. "/api/generate", "-d", vim.json.encode(state.payload) },
        nil,
        function(_)
            vim.schedule(function() vim.notify("cospaget ready") end)
        end
    )
end

function M.post(opts)
    log(opts.body)

    local file = io.open(M.last_prompt_file, "w")
    if file ~= nil then
        file:write(opts.body.prompt)
        if opts.body.suffix ~= nil then file:write(opts.body.suffix) end
        file:close()
    end

    vim.g.model_churning = true
    local c = nil
    if state.ongoing ~= nil then state.ongoing:kill(9) end
    vim.notify("cospaget brewing")
    local think_opened = false
    state.ongoing = vim.system(
        { "curl", "-X", "POST", "-v", "--no-buffer", M.host .. "/api/generate", "-d", vim.json.encode(opts.body) },
        {
            text = true,
            stdout = function(_, data)
                if data == nil then return end
                vim.schedule(function()
                    local ok, d = pcall(vim.json.decode, data)
                    if not ok then
                        if c == nil then
                            c = data
                            return
                        else
                            ok, d = pcall(vim.json.decode, c .. data)
                            if not ok then
                                c = nil
                                return
                            end
                        end
                    end
                    if d.thinking ~= nil and M.show_thinking then
                        if not think_opened then
                            M.insert_text({ "<think>", "" })
                            think_opened = true
                        end

                        local lines = vim.split(d.thinking, "\n")
                        M.insert_text(lines)
                    end

                    if d.error ~= nil then
                        local lines = vim.split(d.error, "\n")
                        M.insert_text(lines)
                    else
                        if d.response ~= "" then
                            if think_opened then
                                M.insert_text({ "</think>", "", "", "" })
                                think_opened = false
                                thinking_hl()
                            end

                            local lines = vim.split(d.response, "\n")
                            M.insert_text(lines)
                        end
                    end
                    if d.done then
                        file = io.open(M.last_response, "w")
                        if file ~= nil then
                            file:write(table.concat(vim.api.nvim_buf_get_lines(state.output_buf, 0, -1, false), "\n"))
                            file:close()
                        end
                        vim.api.nvim_set_option_value("modifiable", state.editable, { buf = state.output_buf })
                        state.done = vim.api.nvim_buf_set_extmark(
                            state.output_buf,
                            ns,
                            0,
                            0,
                            { virt_text = { { "✓ done", "Todo" } } }
                        )
                        state.ongoing = nil
                        vim.g.model_churning = nil
                        vim.notify("cospaget done")
                        if opts.callback then
                            opts.callback({
                                origin_buf = state.origin_buf,
                                origin_win = state.origin_win,
                                output_buf = state.output_buf,
                            })
                        end
                    end
                end)
            end,
        }
    )
end

function M.select_model(callback)
    vim.system({ "curl", M.host .. "/api/tags" }, {
        text = true,
    }, function(out)
        local d = vim.json.decode(out.stdout)

        local models = {}

        for _, m in ipairs(d.models) do
            table.insert(models, m.name)
        end

        vim.ui.select(models, {}, function(choice)
            if choice == nil then return end
            M.model = choice
            if type(callback) == "function" then callback() end
        end)
    end)
end

local function split_prompt(callback)
    if state.chat_buf == nil then state.chat_buf = vim.api.nvim_create_buf(false, true) end
    local c = vim.api.nvim_get_current_buf()
    if c ~= state.chat_buf then state.origin_buf = c end
    vim.cmd.split()
    vim.api.nvim_set_current_buf(state.chat_buf)
    vim.api.nvim_buf_set_name(state.chat_buf, "cospaget | " .. M.model)
    vim.opt_local.winbar = "%f"
    vim.keymap.set("n", "<cr>", function()
        local text = vim.api.nvim_buf_get_text(state.chat_buf, 0, 0, -1, -1, {})
        callback(table.concat(text, "\n"))
    end, { buffer = state.chat_buf })
end

---@class ChatParams
---@field prompt string prompt
---@field use_system boolean use system prompt
---@field use_think boolean? use thinking mode
---@field model string? model to use
---@field style string? prompt style
---@field callback fun()? call after response

---@param opts? ChatParams
function M.generate(opts)
    opts = opts or {}
    state.origin_buf = vim.api.nvim_get_current_buf()
    state.origin_win = vim.api.nvim_get_current_win()

    state.editable = false
    local model = opts.model or M.model
    if not model then
        M.select_model(function() M.generate(opts) end)
        return
    end
    M.wake()

    local function go(input)
        input = replace_placeholders(state.origin_buf, state.output_buf, input)
        if opts.use_system ~= false then input = M.system .. input end
        local use_thinking = M.params.think
        if opts.use_think ~= nil then use_thinking = opts.use_think end
        vim.notify(string.format("thinking: %s", use_thinking))
        state.payload = {
            model = model,
            prompt = input,
            keep_alive = M.keep_alive,
            think = use_thinking,
        }

        open_buf("markdown")
        open_split("# " .. model)
        vim.api.nvim_set_current_win(state.origin_win)

        M.post({ body = state.payload, callback = opts.callback })
    end

    if opts.prompt ~= nil then
        go(opts.prompt)
        return
    end

    split_prompt(function(input)
        if input == nil then return end
        go(input)
    end)
end

function M.prompts(opts)
    for cmd, prompt in pairs(opts) do
        if type(prompt) == "string" then
            vim.api.nvim_create_user_command(cmd, function() M.generate({ prompt = prompt }) end, {})
        elseif type(prompt) == "table" then
            vim.api.nvim_create_user_command(cmd, function() M.generate(prompt) end, {})
        end
    end
end

return M
