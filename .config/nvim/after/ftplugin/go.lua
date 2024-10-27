vim.opt_local.expandtab = false
vim.opt_local.tabstop = 8

vim.opt_local.errorformat = {
    "%Z%f:%l:%c: %m",
    "%Z%f:%l: %m",
    "%E--- FAIL: %o %.%#",
    "%f:%l:%c: %m",
    "%f:%l: %m",
    "%-G%.%#",
}
