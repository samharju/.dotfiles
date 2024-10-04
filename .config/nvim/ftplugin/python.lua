vim.bo.errorformat = {
    "%Z%f:%l: %m",
    "%Z%\\%%(%.%#Error: %\\)%\\@=%m",
    "%C%.%#",
    "%EE%\\s+%m",
    "%EFAIL: %o %.%#",
    "%EERROR: %m (%o\\)",
    "%f:%l: %m",
    "%\\%%(%.%#Error: %\\)%\\@=%m",
    "%-G%.%#",
}

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
    local winid = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        width = 38,
        height = 5,
        row = vim.o.lines / 2,
        col = vim.o.columns / 2 - 19,
        style = "minimal",
        border = "rounded",
    })
    vim.fn.matchadd("DiagnosticWarn", msg)
    vim.wo[winid].winhl = "FloatBorder:DiagnosticWarn"

    vim.defer_fn(function() vim.api.nvim_win_close(winid, true) end, 4000)
end
