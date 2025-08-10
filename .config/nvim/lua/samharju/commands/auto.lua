local grp = vim.api.nvim_create_augroup("sharju_commands", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

local fg_from = function(group)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    return hl.fg
end

autocmd({ "VimEnter", "ColorScheme" }, {
    group = grp,
    pattern = "*",
    callback = function()
        vim.fn.matchadd("Todo", [[.*\(TODO\|FIXME\|\<FIX\>\|breakpoint(\?)\?\).*]], 100)

        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = fg_from("DiagnosticError") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = fg_from("DiagnosticWarn") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = fg_from("DiagnosticInfo") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = fg_from("DiagnosticHint") })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { undercurl = true, sp = fg_from("DiagnosticOk") })

        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "Keyword", default = true })

        vim.api.nvim_set_hl(0, "CmpItemKindClass", { link = "Type", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "Function", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { link = "Keyword", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindConstant", { link = "Constant", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction", { link = "Function", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindOperator", { link = "Operator", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindVariable", { link = "Variable", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "Comment", default = true })
        vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { link = "Type", default = true })

        vim.api.nvim_set_hl(0, "fugitiveUntrackedModifier", { link = "Special", default = true })
        vim.api.nvim_set_hl(0, "fugitiveUnstagedModifier", { link = "Changed", default = true })
        vim.api.nvim_set_hl(0, "fugitiveStagedModifier", { link = "Added", default = true })
        vim.api.nvim_set_hl(0, "fugitiveHunk", { link = "Comment", default = true })

        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
        vim.api.nvim_set_hl(0, "GitSignsAddInline", { link = "added" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { link = "removed" })
        vim.api.nvim_set_hl(0, "GitSignsChangeInline", { link = "changed" })

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

local function trace()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.cmd.split()
    vim.api.nvim_set_current_buf(buf)

    autocmd("LspProgress", {
        group = grp,
        callback = function(event) vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(vim.inspect(event), "\n")) end,
    })
end

local function proge()
    autocmd("LspProgress", {
        group = grp,
        callback = function(event)
            local e = event.data.params.value
            local lsp = vim.lsp.get_client_by_id(event.data.client_id).name
            if e.kind == "begin" then vim.print(string.format("[%s]: %s %s", lsp, e.title, e.message or "")) end
        end,
    })
    vim.g.proge_created = 1

end
