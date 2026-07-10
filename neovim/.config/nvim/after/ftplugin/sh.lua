vim.opt.expandtab = true
if vim.fn.expand("%:t"):match("%.env") then vim.diagnostic.enable(false) end
