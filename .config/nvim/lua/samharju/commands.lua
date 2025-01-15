local cmd = vim.api.nvim_create_user_command

-- cmon not an editor command: W
cmd("W", "w", {})

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

local grp = vim.api.nvim_create_augroup("sharju_commands", { clear = true })

local fg_from = function(group)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    return hl.fg
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = grp,
    pattern = "*",
    callback = function()
        vim.fn.matchadd("Todo", [[TODO\|FIXME\|\<FIX\>]], 100)

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
        vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { link = "TypeParameter", default = true })

        vim.api.nvim_set_hl(0, "fugitiveUnstagedModifier", { link = "Removed", default = true })
        vim.api.nvim_set_hl(0, "fugitiveStagedModifier", { link = "Added", default = true })

        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })

        vim.cmd([[hi! link @custom_injection ColorColumn]])
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = grp,
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_user_command("GitLineHistory", function()
    local start = vim.fn.getpos("'<")
    local stop = vim.fn.getpos("'>")

    vim.cmd(string.format("Git log -L %s,%s:%s", start[2], stop[2], vim.fn.expand("%")))
end, { range = 1 })
