vim.bo.textwidth = 72

vim.fn.matchadd("DiagnosticWarn", "\\%>50v.", 1)
vim.fn.matchadd("DiagnosticError", "\\%>72v.", 2)
