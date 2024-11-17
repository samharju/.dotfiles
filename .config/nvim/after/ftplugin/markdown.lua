vim.opt_local.textwidth = 100
vim.opt_local.linebreak = true
vim.opt_local.wrap = true
vim.opt_local.shiftwidth = 2

local fname = vim.fn.fnamemodify(vim.fn.expand("%"), ":~")
local notes = vim.fn.fnamemodify(vim.fn.expand("~/notes"), ":~")
if string.match(fname, notes) then vim.opt.filetype = "markdown.mynotes" end
