vim.opt_local.errorformat = {
    '  File "%f"\\, line %l%m',
    "ERROR %f::%o - %m",
    "%+GFAILED %.%#",
    "%+GERROR %.%#",
    "E %#%\\%%(-%\\)%\\@=%m",
    "E %#%\\%%(+%\\)%\\@=%m",
    "E %#%\\%%(\\?%\\)%\\@=%m",
    "E %#%\\%%(%.%#%trror: %\\)%\\@=%m",
    "%\\%%(%.%#%trror: %\\)%\\@=%m",
    "%f:%l: %m",
    "%f:%l:",
    "%+GTraceback %.%#",
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
        msg,
        "",
    })
    local w = 38
    local h = 7
    local winid = vim.api.nvim_open_win(buf, false, {
        relative = "win",
        width = w,
        height = 3,
        row = vim.o.lines - h - 2,
        col = vim.o.columns - w - 5,
        style = "minimal",
        border = "rounded",
    })
    vim.wo[winid].winhl = "FloatBorder:DiagnosticWarn,Normal:DiagnosticWarn"

    vim.defer_fn(function() vim.api.nvim_win_close(winid, true) end, 4000)
end

require("samharju.custom.py_param")
