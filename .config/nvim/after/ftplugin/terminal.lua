vim.fn.matchadd("DiagnosticError", [[\c\<\w*error]])
vim.fn.matchadd("DiagnosticWarning", [[\c\<\w*warning]])
vim.fn.matchadd("DiagnosticInfo", [[\c\<\w*info]])
vim.fn.matchadd("DiagnosticHint", [[\c\<\w*debug]])
