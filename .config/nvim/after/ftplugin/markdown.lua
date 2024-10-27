vim.opt_local.textwidth = 100
vim.opt_local.linebreak = true
vim.opt_local.wrap = true
vim.opt_local.shiftwidth = 2

if string.match(vim.fn.expand("%"), vim.fn.expand("~/notes")) then vim.opt.filetype = "markdown.mynotes" end
