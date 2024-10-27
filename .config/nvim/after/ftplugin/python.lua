vim.opt_local.errorformat = {
    "%CE %#%m",
    "%Z%f:%l: %m",
    "%Z%\\%%(%.%#%trror: %\\)%\\@=%m",
    "%C%.%#",
    "%E_%# %o _%#",
    "%EE %#%m",
    "%EFAIL: %m (%o)",
    "%EERROR: %m (%o)",
    "%f:%l: %m",
    '%+G  File "%f"\\, line %l\\, in %m',
    "%\\%%(%.%#%trror: %\\)%\\@=%m",
    "%-G%.%#",
}

-- vim.cmd("cgetfile /tmp/yeeterr")

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
        row = vim.o.lines / 2 - h / 2,
        col = vim.o.columns / 2 - w / 2,
        style = "minimal",
        border = "rounded",
    })
    vim.wo[winid].winhl = "FloatBorder:DiagnosticWarn,Normal:DiagnosticWarn"

    vim.defer_fn(function() vim.api.nvim_win_close(winid, true) end, 3000)
end

if exists and not active then
    vim.keymap.set("n", "<leader>go", ":!venv/bin/python %<CR>", { buffer = true })
else
    vim.keymap.set("n", "<leader>go", ":!python %<CR>", { buffer = true })
end
