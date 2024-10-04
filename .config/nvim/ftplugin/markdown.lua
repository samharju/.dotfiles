vim.bo.textwidth = 100
vim.wo.linebreak = true
vim.wo.wrap = true

if string.match(vim.fn.expand("%"), vim.fn.expand("~/notes")) then vim.opt.filetype = "markdown.mynotes" end
