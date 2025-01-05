vim.bo.textwidth = 80

vim.fn.matchadd("DiagnosticDeprecated", "\\%1l\\%>50v.", 1)
vim.fn.matchadd("DiagnosticDeprecated", "\\%2l.", 1)
