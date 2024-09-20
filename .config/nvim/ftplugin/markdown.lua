vim.bo.textwidth = 100
vim.opt.linebreak = true
vim.opt.wrap = true

if string.match(vim.fn.expand("%"), vim.fn.expand("~/notes")) then vim.opt.filetype = "markdown.mynotes" end
