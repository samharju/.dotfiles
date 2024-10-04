local cmd = vim.api.nvim_create_user_command

-- cmon not an editor command: W
cmd("W", "w", {})

cmd("Breakpoints", function()
    vim.cmd([[ silent grep! -F 'breakpoint()']])
    vim.cmd([[ copen ]])
end, {})

-- clear registers
cmd("ClearRegs", function(_)
    local regs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for r in regs:gmatch(".") do
        local val = vim.fn.getreg(r)
        if val ~= "" then vim.fn.setreg(r, "") end
    end
end, { desc = "Clear registers abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" })

cmd(
    "DiagnosticToggle",
    function(_) vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
    { desc = "Toggle diagnostics" }
)

local grp = vim.api.nvim_create_augroup("sharju_commands", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = grp,
    pattern = "*",
    callback = function()
        vim.fn.matchadd("Function", [[TODO\|FIXME\|\<FIX\>]], 100)

        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { italic = true })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = grp,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Search",
            timeout = 200,
        })
    end,
})
