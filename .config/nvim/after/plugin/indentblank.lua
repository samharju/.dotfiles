vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"

require("indent_blankline").setup {
    show_current_context = true,
}
