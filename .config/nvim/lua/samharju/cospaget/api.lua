local M = {
    host = "http://10.0.2.2:11434",
    model = "qwen3:4b",
    keep_alive = "30m",
    params = { think = true, temperature = 1, top_k = 10 },
    show_thinking = true,
    system = "",
    prompt = "center",
    last_prompt_file = "/tmp/nvim_cospaget_last_prompt",
    last_response = "/tmp/nvim_cospaget",
}

local comp_win = -1
local chat_win = -1

local origin_buf = -1
local origin_win = -1
local output_buf = -1
local editable = false

local ongoing = nil
local payload = nil
local done = nil

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

local ns = vim.api.nvim_create_namespace("cospaget")

local function open_buf(ftype)
    if vim.api.nvim_buf_is_valid(output_buf) then
        vim.api.nvim_set_option_value("modifiable", true, { buf = output_buf })
        vim.api.nvim_buf_set_text(output_buf, 0, 0, -1, -1, {})
        if done ~= nil then vim.api.nvim_buf_clear_namespace(output_buf, ns, 0, -1) end
    else
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t") == "cospaget" then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
        output_buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(output_buf, "cospaget")
    end

    if ftype ~= nil then
        vim.api.nvim_set_option_value("filetype", ftype, { buf = output_buf })
    elseif origin_buf ~= -1 then
        vim.api.nvim_set_option_value("filetype", vim.bo[origin_buf].filetype, { buf = output_buf })
    end
    vim.api.nvim_set_option_value("modifiable", true, { buf = output_buf })
    vim.diagnostic.enable(false, { bufnr = output_buf })

    vim.keymap.set("n", "q", function()
        if ongoing ~= nil then ongoing:kill(9) end
        vim.api.nvim_buf_delete(output_buf, { force = true })
    end, { buffer = output_buf })

    vim.keymap.set("n", "<c-space>", function()
        local feed = vim.api.nvim_buf_get_lines(output_buf, 0, -1, false)
        vim.api.nvim_win_close(comp_win, true)
        if feed ~= nil then vim.api.nvim_put(feed, "c", true, false) end
    end, { buffer = output_buf })

    vim.keymap.set("n", "<c-f>", function()
        if ongoing ~= nil then ongoing:kill(9) end
        vim.api.nvim_set_option_value("modifiable", true, { buf = output_buf })
        vim.api.nvim_buf_set_text(output_buf, 0, 0, -1, -1, {})
        if done ~= nil then vim.api.nvim_buf_clear_namespace(output_buf, ns, 0, -1) end
        M.post(payload)
    end, { buffer = output_buf })

    vim.keymap.set("n", "<esc>", function()
        if ongoing ~= nil then
            ongoing:kill(9)
            done = vim.api.nvim_buf_set_extmark(output_buf, ns, 0, 0, { virt_text = { { "✕ stopped", "Error" } } })
            ongoing = nil
        end
    end, { buffer = output_buf })

    vim.keymap.set("v", "<leader>l", function()
        if not vim.api.nvim_buf_is_valid(output_buf) then return end

        vim.cmd.normal("!<Esc>")
        local start = vim.fn.getpos("'<")
        local finish = vim.fn.getpos("'>")
        local lines = vim.api.nvim_buf_get_lines(output_buf, start[2], finish[2], false)
        log("lines")
        log(lines)

        local opos = vim.api.nvim_win_get_cursor(origin_win)

        vim.api.nvim_buf_set_lines(origin_buf, opos[1], opos[1], false, lines)
    end, { buffer = output_buf })
end

function M.insert_text(text, grow)
    vim.api.nvim_buf_set_text(output_buf, -1, -1, -1, -1, text)
    if not grow then return end
    local l = vim.api.nvim_buf_line_count(output_buf)
    if l > vim.api.nvim_win_get_height(comp_win) then vim.api.nvim_win_set_height(comp_win, l) end
end

local function winopts(win)
    vim.api.nvim_set_option_value("wrap", true, { win = win })
    vim.cmd.stopinsert()
end

local function open_split()
    vim.api.nvim_buf_set_text(output_buf, 0, 0, -1, -1, { "# " .. M.model, "" })
    if vim.api.nvim_win_is_valid(chat_win) then return end
    vim.cmd.vsplit()
    chat_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_buf(output_buf)
    winopts(chat_win)
end

local function cursor_prompt(title)
    if vim.api.nvim_win_is_valid(comp_win) then return end

    comp_win = vim.api.nvim_open_win(output_buf, true, {
        col = 0,
        row = 0,
        relative = "cursor",
        focusable = true,
        width = 100,
        height = 6,
        border = "rounded",
        style = "minimal",
        title = title,
        title_pos = "center",
    })
    winopts(comp_win)
end

function M.complete(use_suffix)
    origin_buf = vim.api.nvim_get_current_buf()
    origin_win = vim.api.nvim_get_current_win()

    editable = true
    local pre_context = 100
    local post_context = 100
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local start_row = math.max(0, row - 1 - pre_context)
    local end_row = math.min(row - 1 + post_context, vim.api.nvim_buf_line_count(0) - 1)

    local prefix = table.concat(vim.api.nvim_buf_get_text(0, start_row, 0, row - 1, col, {}), "\n")
    local suffix_lines = vim.api.nvim_buf_get_text(0, row - 1, col, end_row, -1, {})
    local suffix = table.concat(suffix_lines, "\n")

    payload = {
        model = M.model,
        prompt = prefix,
        keep_alive = M.keep_alive,
    }

    if use_suffix ~= false then payload.suffix = suffix end

    open_buf()
    cursor_prompt(payload.model)
    M.post(payload, true)
end

local function thinking_hl()
    local s = -1
    local e = -1
    for i, line in ipairs(vim.api.nvim_buf_get_lines(output_buf, 0, -1, false)) do
        if line:match("<think>") then s = i - 1 end
        if line:match("</think>") then e = i end
    end

    if s ~= -1 and e ~= -1 then
        vim.highlight.range(output_buf, ns, "Comment", { s, 0 }, { e, 0 })
        vim.api.nvim_win_set_cursor(chat_win, { e + 3, 0 })
        if vim.api.nvim_get_current_win() == chat_win then vim.fn.feedkeys("z\r") end
    end
end

function M.wake()
    if ongoing then return end
    vim.notify("prewarming cospaget")

    payload = {
        model = M.model,
        prompt = "",
        keep_alive = M.keep_alive,
    }

    vim.system(
        { "curl", "-X", "POST", "-v", "--no-buffer", M.host .. "/api/generate", "-d", vim.json.encode(payload) },
        nil,
        function(_)
            vim.schedule(function() vim.notify("cospaget ready") end)
        end
    )
end

function M.post(body, float)
    log(body)

    local file = io.open(M.last_prompt_file, "w")
    if file ~= nil then
        file:write(body.prompt)
        if body.suffix ~= nil then file:write(body.suffix) end
        file:close()
    end

    vim.g.model_churning = "  "
    local c = nil
    if ongoing ~= nil then ongoing:kill() end
    vim.notify("cospaget brewing")
    local think_opened = false
    ongoing = vim.system(
        { "curl", "-X", "POST", "-v", "--no-buffer", M.host .. "/api/generate", "-d", vim.json.encode(body) },
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
                            M.insert_text({ "<think>", "" }, float)
                            think_opened = true
                        end

                        local lines = vim.split(d.thinking, "\n")
                        M.insert_text(lines, float)
                    end

                    if d.error ~= nil then
                        local lines = vim.split(d.error, "\n")
                        M.insert_text(lines, float)
                    else
                        if d.response ~= "" then
                            if think_opened then
                                M.insert_text({ "</think>", "", "", "" }, float)
                                think_opened = false
                                thinking_hl()
                            end

                            local lines = vim.split(d.response, "\n")
                            M.insert_text(lines, float)
                        end
                    end
                    if d.done then
                        file = io.open(M.last_response, "w")
                        if file ~= nil then
                            file:write(table.concat(vim.api.nvim_buf_get_lines(output_buf, 0, -1, false), "\n"))
                            file:close()
                        end
                        vim.api.nvim_set_option_value("modifiable", editable, { buf = output_buf })
                        done = vim.api.nvim_buf_set_extmark(
                            output_buf,
                            ns,
                            0,
                            0,
                            { virt_text = { { "✓ done", "Todo" } } }
                        )
                        ongoing = nil
                        vim.g.model_churning = nil
                        vim.notify("cospaget done")
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

---@param text string
---@return string
local function replace_placeholders(text)
    if text:match("$buffers") ~= nil then
        local content = ""
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local fname = vim.api.nvim_buf_get_name(buf)
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= output_buf and fname ~= "" then
                local c = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
                content = content .. string.format("\n%s\n---\n%s\n---\n\n", vim.fn.fnamemodify(fname, ":."), c)
            end
        end
        text = text:gsub("$buffers", content)
    end

    if text:match("$buffer") ~= nil then
        local contents = table.concat(vim.api.nvim_buf_get_lines(origin_buf, 0, -1, false), "\n")
        local fname = vim.api.nvim_buf_get_name(origin_buf)
        text = text:gsub("$buffer", string.format("\n%s\n---\n%s\n---\n\n", vim.fn.fnamemodify(fname, ":."), contents))
    end

    if text:match("$yank") ~= nil then
        local y = vim.fn.getreg("")
        text = text:gsub("$yank", y)
    end
    if text:match("$function_def") ~= nil then
        local node = vim.treesitter.get_node()
        local sub = ""
        while true do
            if node == nil then break end
            local t = node:type()
            if t == "function_definition" or t == "function_declaration" then
                sub = vim.treesitter.get_node_text(node, 0)
                break
            end
            node = node:parent()
        end
        text = text:gsub("$function_def", sub)
    end
    if text:match("$filetype") ~= nil then text = text:gsub("$filetype", vim.bo[origin_buf].filetype) end

    if text:match("$diag") ~= nil then
        local d = vim.diagnostic.get_next()
        if d ~= nil then text = text:gsub("$diag", vim.inspect(d)) end
    end

    if text:match("$file:") ~= nil then
        for m in text:gmatch("$file:(%S+)") do
            local file = io.open(m, "r")
            if file ~= nil then
                local contents = file:read("*a")
                text = text:gsub("$file:" .. m, contents)
                file:close()
            else
                text = text:gsub("$file:" .. m, "")
            end
        end
    end

    return text
end

local chatbuf = nil

local function centered_prompt(callback)
    if chatbuf == nil then chatbuf = vim.api.nvim_create_buf(false, true) end
    local c = vim.api.nvim_get_current_buf()
    if c ~= chatbuf then origin_buf = c end

    local w = math.floor(vim.o.columns / 2)
    local h = math.floor(vim.o.lines / 2)
    comp_win = vim.api.nvim_open_win(chatbuf, true, {
        col = math.floor((vim.o.columns - w) / 2),
        row = math.floor((vim.o.lines - h) / 2),
        relative = "editor",
        focusable = true,
        width = w,
        height = h,
        border = "rounded",
        style = "minimal",
        title = "cospaget | " .. M.model .. " | enter to submit",
        title_pos = "center",
    })
    vim.keymap.set("n", "<cr>", function()
        local text = vim.api.nvim_buf_get_text(chatbuf, 0, 0, -1, -1, {})
        callback(table.concat(text, "\n"))
        vim.api.nvim_win_hide(comp_win)
    end, { buffer = chatbuf })
end

local function split_prompt(callback)
    if chatbuf == nil then chatbuf = vim.api.nvim_create_buf(false, true) end
    local c = vim.api.nvim_get_current_buf()
    if c ~= chatbuf then origin_buf = c end
    vim.cmd.split()
    vim.api.nvim_set_current_buf(chatbuf)
    vim.api.nvim_buf_set_name(chatbuf, "cospaget | " .. M.model)
    vim.opt_local.winbar = "%f"
    vim.keymap.set("n", "<cr>", function()
        local text = vim.api.nvim_buf_get_text(chatbuf, 0, 0, -1, -1, {})
        callback(table.concat(text, "\n"))
    end, { buffer = chatbuf })
end

function M.chat(prompt, style, use_system)
    origin_buf = vim.api.nvim_get_current_buf()
    origin_win = vim.api.nvim_get_current_win()

    editable = false
    if M.model == nil then
        M.select_model(function() M.chat(prompt) end)
        return
    end
    M.wake()

    local function go(input)
        input = replace_placeholders(input)
        if use_system ~= false then input = M.system .. input end
        payload = {
            model = M.model,
            prompt = input,
            keep_alive = M.keep_alive,
            think = M.params.think,
        }
        if style == "float" then
            open_buf()
            cursor_prompt(payload.model)
        else
            open_buf("markdown")
            open_split()
        end
        M.post(payload, style == "float")
    end

    if prompt ~= nil then
        go(prompt)
        return
    end

    if M.prompt == "center" then
        centered_prompt(function(input)
            if input == nil then return end
            go(input)
        end)
    elseif M.prompt == "split" then
        split_prompt(function(input)
            if input == nil then return end
            go(input)
        end)
    end
end

function M.prompts(opts)
    for cmd, prompt in pairs(opts) do
        if type(prompt) == "string" then
            vim.api.nvim_create_user_command(cmd, function() M.chat(prompt) end, {})
        elseif type(prompt) == "table" then
            vim.api.nvim_create_user_command(cmd, function() M.chat(prompt.prompt, nil, prompt.use_system) end, {})
        end
    end
end

return M
