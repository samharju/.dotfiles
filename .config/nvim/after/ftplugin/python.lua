vim.opt_local.errorformat = {
    '  File "%f"\\, line %l\\, in %m',
    "%-GFAILED %.%#",
    "%-GERROR %.%#",
    "ERROR %f::%o - %m",
    "E%\\%%(     -%\\)%\\@=%m",
    "E%\\%%(     +%\\)%\\@=%m",
    "E%\\%%(     \\?%\\)%\\@=%m",
    "E  %\\%%(%.%#%trror: %\\)%\\@=%m",
    "%\\%%(%.%#%trror: %\\)%\\@=%m",
    "%f:%l: %m",
    "%f:%l:",
    "%-G%.%#",
}

vim.api.nvim_create_user_command("RefreshEfm", function()
    vim.cmd([[ so ~/.config/nvim/after/ftplugin/python.lua ]])
    vim.cmd.cgetfile("/tmp/yeeterr")
end, {})

local active, exists, _ = require("samharju.venv").check_venv()

if exists and not active then
    local buf = vim.api.nvim_create_buf(false, true)
    local msg = "          venv not activated"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "",
        "",
        msg,
        "",
        "",
    })
    local w = 38
    local h = 7
    local winid = vim.api.nvim_open_win(buf, false, {
        relative = "win",
        width = w,
        height = 5,
        row = vim.o.lines - h - 5,
        col = vim.o.columns - w - 4,
        style = "minimal",
        border = "rounded",
    })
    vim.wo[winid].winhl = "FloatBorder:DiagnosticWarn,Normal:DiagnosticWarn"

    vim.defer_fn(function() vim.api.nvim_win_close(winid, true) end, 4000)
end

if exists and not active then
    vim.keymap.set("n", "<leader>x", ":!venv/bin/python %<CR>", { buffer = true })
else
    vim.keymap.set("n", "<leader>x", ":!python %<CR>", { buffer = true })
end

require("samharju.custom.py_param")
