local M = {
    host = "http://10.0.2.2:11434",
    model = "llama3.2:latest",
    keep_alive = "10m",
}

local compwin = -1
local chatwin = -1

local curbuf = -1
local ollamabuf = -1

local ongoing = nil
local payload = nil
local done = nil

local logfile = vim.fn.stdpath("cache") .. "/ollama.log"

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

local ns = vim.api.nvim_create_namespace("complama")

local function open_buf(ftype)
    if vim.api.nvim_buf_is_valid(ollamabuf) then
        vim.api.nvim_set_option_value("modifiable", true, { buf = ollamabuf })
        vim.api.nvim_buf_set_text(ollamabuf, 0, 0, -1, -1, {})
        if done ~= nil then vim.api.nvim_buf_clear_namespace(ollamabuf, ns, 0, -1) end
    else
        ollamabuf = vim.api.nvim_create_buf(false, true)
    end

    if ftype ~= nil then
        vim.api.nvim_set_option_value("filetype", ftype, { buf = ollamabuf })
    elseif curbuf ~= -1 then
        vim.api.nvim_set_option_value("filetype", vim.bo[curbuf].filetype, { buf = ollamabuf })
    end
    vim.api.nvim_set_option_value("modifiable", true, { buf = ollamabuf })
    vim.diagnostic.enable(false, { bufnr = ollamabuf })

    vim.keymap.set("n", "q", function()
        if ongoing ~= nil then ongoing:kill(9) end
        vim.api.nvim_buf_delete(ollamabuf, { force = true })
    end, { buffer = ollamabuf })

    vim.keymap.set("n", "<c-space>", function()
        local feed = vim.api.nvim_buf_get_lines(ollamabuf, 0, -1, false)
        vim.api.nvim_win_close(compwin, true)
        if feed ~= nil then vim.api.nvim_put(feed, "c", true, false) end
    end, { buffer = ollamabuf })

    vim.keymap.set("n", "<c-f>", function()
        if ongoing ~= nil then ongoing:kill(9) end
        vim.api.nvim_set_option_value("modifiable", true, { buf = ollamabuf })
        vim.api.nvim_buf_set_text(ollamabuf, 0, 0, -1, -1, {})
        if done ~= nil then vim.api.nvim_buf_clear_namespace(ollamabuf, ns, 0, -1) end
        M.post(payload)
    end, { buffer = ollamabuf })

    vim.keymap.set("n", "<esc>", function()
        if ongoing ~= nil then
            ongoing:kill(9)
            done =
                vim.api.nvim_buf_set_extmark(ollamabuf, ns, 0, 0, { virt_lines = { { { "✕ stopped", "Error" } } } })
            ongoing = nil
        end
    end, { buffer = ollamabuf })
end

function M.insert_text(text, grow)
    vim.api.nvim_buf_set_text(ollamabuf, -1, -1, -1, -1, text)
    if not grow then return end
    local l = vim.api.nvim_buf_line_count(ollamabuf)
    if l > vim.api.nvim_win_get_height(compwin) then vim.api.nvim_win_set_height(compwin, l) end
end

local function winopts(win)
    vim.api.nvim_set_option_value("wrap", true, { win = win })
    vim.cmd.stopinsert()
end

local function open_split()
    vim.api.nvim_buf_set_text(ollamabuf, 0, 0, -1, -1, { "# " .. M.model, "" })
    if vim.api.nvim_win_is_valid(chatwin) then return end
    vim.cmd.vsplit()
    chatwin = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_buf(ollamabuf)
    winopts(chatwin)
end

local function cursor_prompt(title)
    if vim.api.nvim_win_is_valid(compwin) then return end

    compwin = vim.api.nvim_open_win(ollamabuf, true, {
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
    winopts(compwin)
end

function M.complete(use_suffix)
    if M.model == nil then
        M.select_model(M.complete)
        return
    end
    curbuf = vim.api.nvim_get_current_buf()
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
        options = {
            temperature = 0,
            num_predict = 128,
            top_p = 0.9,
            stop = {
                "<EOT>",
                "<|file_separator|>",
                "<|fim_prefix|>",
                "<|fim_suffix|>",
                "<|fim_middle|>",
                "<|file_separator|>",
            },
        },
        prompt = prefix,
        keep_alive = M.keep_alive,
    }

    if use_suffix ~= false then payload.suffix = suffix end

    open_buf()
    cursor_prompt(payload.model)
    M.post(payload, true)
end

function M.post(body, float)
    log(body)
    vim.g.model_churning = "  "
    local c = nil
    if ongoing ~= nil then ongoing:kill() end
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
                    if d.error ~= nil then
                        local lines = vim.split(d.error, "\n")
                        M.insert_text(lines, float)
                    else
                        local lines = vim.split(d.response, "\n")
                        M.insert_text(lines, float)
                    end
                    if d.done then
                        vim.api.nvim_set_option_value("modifiable", false, { buf = ollamabuf })
                        done = vim.api.nvim_buf_set_extmark(
                            ollamabuf,
                            ns,
                            0,
                            0,
                            { virt_lines = { { { "✓ done", "Todo" } } } }
                        )
                        ongoing = nil
                        vim.g.model_churning = nil
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
    if text:match("$buffer") ~= nil then
        local t = vim.api.nvim_buf_get_text(curbuf, 0, 0, -1, -1, {})
        local y = table.concat(t, "\n")
        text = text:gsub("$buffer", y)
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
    if text:match("$filetype") ~= nil then text = text:gsub("$filetype", vim.bo[0].filetype) end
    return text
end

local chatbuf = nil

local function centered_prompt(callback)
    if chatbuf == nil then chatbuf = vim.api.nvim_create_buf(false, true) end
    curbuf = vim.api.nvim_get_current_buf()

    local w = 120
    local h = 12
    compwin = vim.api.nvim_open_win(chatbuf, true, {
        col = math.floor((vim.o.columns - w) / 2),
        row = math.floor((vim.o.lines - h) / 2),
        relative = "editor",
        focusable = true,
        width = w,
        height = h,
        border = "rounded",
        style = "minimal",
        title = M.model .. " | enter to submit",
        title_pos = "center",
    })
    vim.keymap.set("n", "<cr>", function()
        local text = vim.api.nvim_buf_get_text(chatbuf, 0, 0, -1, -1, {})
        callback(table.concat(text, "\n"))
        vim.api.nvim_win_hide(compwin)
    end, { buffer = chatbuf })
end

local function chat(prompt, style)
    if M.model == nil then
        M.select_model(function() chat(prompt) end)
        return
    end

    local function go(input)
        input = replace_placeholders(input)
        payload = {
            model = M.model,
            prompt = input,
            keep_alive = M.keep_alive,
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

    centered_prompt(function(input)
        if input == nil then return end
        go(input)
    end)
end

vim.api.nvim_create_user_command("OllamaModel", M.select_model, {})
vim.api.nvim_create_user_command("OllamaChat", function() chat() end, {})
vim.api.nvim_create_user_command(
    "OllamaDocstring",
    function()
        chat([[
Generate short docstring for this function. Respond with the $filetype docstring and nothing else.

$function_def
]])
    end,
    {}
)

vim.keymap.set("i", "<c-f>", function() M.complete(true) end)
vim.keymap.set("n", "<leader>co", "<cmd>OllamaChat<CR>")
vim.keymap.set("n", "<leader>l", function()
    if not vim.api.nvim_buf_is_valid(ollamabuf) then return end

    local lines = vim.api.nvim_buf_get_lines(ollamabuf, 0, -1, false)
    vim.api.nvim_put(lines, "c", true, true)
end)
