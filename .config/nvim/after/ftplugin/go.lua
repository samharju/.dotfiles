vim.opt_local.expandtab = false
vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8

vim.opt_local.errorformat = {
    "%-G%\\d%\\+%.%#", -- lines starting with number are most likely logs
    "%f:%l:%c: %m", -- lone filename:lineno:column
    "%f:%l: %m", -- lone filename:lineno:column
    "%+G %#--- FAIL:%.%#",
    "%-G%.%#",
}
