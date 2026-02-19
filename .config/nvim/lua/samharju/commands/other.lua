local cmd = vim.api.nvim_create_user_command

-- cmon not an editor command: W
cmd("W", "w", {})

cmd("Scratch", function(args)
    vim.cmd([[ vert new ]])
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
    if args.args then vim.bo.filetype = args.args end
end, { nargs = "?", complete = function() return { "python", "markdown" } end })

cmd("JQNIZE", function()
    local ts = vim.treesitter

    local n = ts.get_node()
    if n == nil then return end
    local txt = ts.get_node_text(n, 0)

    txt = txt:gsub("^'", "")
    txt = txt:gsub("'$", "")
    local res = vim.system({ "jq" }, {
        stdin = txt,
        text = true,
    }):wait()

    local buf = vim.api.nvim_create_buf(false, true)
    vim.keymap.set("n", "<CR>", "ggyG", { buffer = buf })
    vim.keymap.set("n", "q", function() vim.api.nvim_buf_delete(buf, {}) end, { buffer = buf })

    local output = vim.split("'\n" .. res.stdout .. "'", "\n")
    if res.code ~= 0 then output = vim.split(res.stderr, "\n") end

    vim.api.nvim_buf_set_text(buf, 0, 0, -1, -1, output)

    local w = math.floor(vim.o.columns * 0.8)
    local h = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - w) / 2)
    local row = math.floor((vim.o.lines - h) / 2)
    vim.api.nvim_open_win(
        buf,
        true,
        { relative = "editor", col = col, row = row, width = w, height = h, style = "minimal", border = "rounded" }
    )
end, {})

cmd("Breakpoints", function()
    vim.cmd([[ silent grep! -F 'breakpoint()']])
    vim.cmd([[ copen ]])
end, {})

cmd("ToggleDiagnostics", function(args)
    local conf = vim.diagnostic.config()
    if conf == nil then return end
    local opts = {
        all = function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
        signs = function() vim.diagnostic.config({ signs = not conf.signs }) end,
        virtual_text = function()
            vim.diagnostic.config({
                virtual_text = not conf.virtual_text,
            })
        end,
    }
    for _, c in ipairs(args.fargs) do
        opts[c]()
    end
end, { desc = "Toggle diagnostics", nargs = "+", complete = function() return { "all", "virtual_text" } end })

cmd("GitLineHistory", function()
    local start = vim.fn.getpos("'<")
    local stop = vim.fn.getpos("'>")

    vim.cmd(string.format("Git log -L %s,%s:%s", start[2], stop[2], vim.fn.expand("%:p")))
end, { range = 1 })

cmd("Whatnow", function()
    local w = 80
    local h = 40
    local row = math.ceil((vim.o.lines - h) * 0.5)
    local col = math.ceil((vim.o.columns - w) * 0.5)

    vim.api.nvim_open_win(0, true, {
        col = col,
        row = row,
        relative = "editor",
        focusable = true,
        width = w,
        height = h,
        border = "rounded",
        style = "minimal",
        title = "what now",
        title_pos = "center",
    })

    vim.cmd.term("whatnow")
    vim.cmd.startinsert()
end, {})

cmd("LastCommit", function()
    vim.system({ "git", "-C", vim.uv.cwd(), "log", "-1", "--pretty=%B" }, { text = true }, function(out)
        local b = out.stdout:match("([^\n]+)")
        if b ~= nil then vim.notify(b) end
    end)
end, {})
