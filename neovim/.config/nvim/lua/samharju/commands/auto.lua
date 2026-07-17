local grp = vim.api.nvim_create_augroup("sharju_commands", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

local fg_from = function(group)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    return hl.fg
end

autocmd("BufEnter", {
    group = grp,
    pattern = "todos.md",
    callback = function() vim.fn.matchadd("DiagnosticVirtualTextOk", [[.*DONE.*]], 100) end,
})

autocmd({ "VimEnter" }, {
    group = grp,
    callback = function(args)
        if vim.fn.isdirectory(args.file) ~= 0 then vim.api.nvim_set_current_dir(args.file) end
    end,
})

autocmd({ "VimEnter", "ColorScheme", "BufEnter" }, {
    group = grp,
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "BreakpointHL", { link = "DiagnosticVirtualTextError" })
        vim.fn.matchadd("DiagnosticVirtualTextWarn", [[^\s*\zs.*\(TODO\|FIXME\|\<FIX\>\).*\|breakpoint(.*)]], 100)
        vim.fn.matchadd("DiagnosticVirtualTextWarn", [[^\(<<<<<<<\|>>>>>>>\|=======\).*]], 100)

        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = fg_from("DiagnosticError") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = fg_from("DiagnosticWarn") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, sp = fg_from("DiagnosticInfo") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, sp = fg_from("DiagnosticHint") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { undercurl = false, sp = fg_from("DiagnosticOk") })

        for k, v in pairs({
            Class = "Type",
            Method = "Function",
            Keyword = "Keyword",
            Constant = "Constant",
            Function = "Function",
            Operator = "Operator",
            Variable = "Variable",
            Text = "Comment",
            Snippet = "Type",
        }) do
            vim.api.nvim_set_hl(0, string.format("BlinkCmpKind%s", k), { link = v })
        end

        vim.api.nvim_set_hl(0, "fugitiveUntrackedModifier", { link = "Special", default = true })
        vim.api.nvim_set_hl(0, "fugitiveUnstagedModifier", { link = "Changed", default = true })
        vim.api.nvim_set_hl(0, "fugitiveStagedModifier", { link = "Added", default = true })
        vim.api.nvim_set_hl(0, "fugitiveHunk", { link = "Comment", default = true })

        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment", default = true })
        vim.api.nvim_set_hl(0, "GitSignsAddInline", { link = "added", default = true })
        vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { link = "removed", default = true })
        vim.api.nvim_set_hl(0, "GitSignsChangeInline", { link = "changed", default = true })

        vim.api.nvim_set_hl(0, "NvimTreeGitFileIgnoredHL", { fg = fg_from("Comment"), italic = true })

        vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })

        vim.cmd([[hi! link @custom_injection ColorColumn]])
    end,
})

autocmd("TextYankPost", {
    group = grp,
    callback = function() vim.highlight.on_yank() end,
})

autocmd("BufReadPre", {
    group = grp,
    pattern = { "*.json", "*.txt", "*.log" },
    callback = function(args)
        local ok, s = pcall(function() return vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf)) end)
        if not ok or not s then return end

        if s.size > 1000000 then
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.swapfile = false
            vim.opt_local.syntax = "off"
            vim.treesitter.stop(args.buf)
        end
    end,
})

local function runcmd(args, opts)
    opts = opts or {}
    if opts.stdout ~= false then require("samharju.notify").topright(table.concat(args, " ")) end
    local c = nil
    if opts.callback then c = vim.schedule_wrap(opts.callback) end

    vim.system(args, {
        text = true,
        stdout = vim.schedule_wrap(function(_, data) require("samharju.notify").topright(data) end),
        stderr = vim.schedule_wrap(function(_, data) require("samharju.notify").topright(data) end),
    }, c)
end

autocmd("VimEnter", {
    group = grp,
    callback = function()
        runcmd({ "git", "rev-parse", "HEAD" }, {
            callback = function(out)
                if out.code ~= 0 then return end
                runcmd(
                    { "git", "fetch", "--all" },
                    { callback = function() runcmd({ "git", "status", "--short" }) end }
                )
            end,
        })
    end,
})

autocmd("BufNew", {
    callback = function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
        if #bufs <= 10 then return end

        local wins = vim.api.nvim_list_wins()
        local visible_bufs = {}
        for _, win in ipairs(wins) do
            local vbuf = vim.api.nvim_win_get_buf(win)
            visible_bufs[tostring(vbuf)] = true
        end

        local to_delete = -1
        local used = 0

        local t = os.time()
        for _, buf in ipairs(bufs) do
            if visible_bufs[tostring(buf.bufnr)] == nil then
                local since = t - buf.lastused
                if since > used then
                    used = since
                    to_delete = buf.bufnr
                end
            end
        end
        if to_delete <= 0 then return end

        vim.notify("Dropped " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(to_delete), ":t"))
        vim.cmd("bdelete " .. to_delete)
    end,
})
