vim.fn.matchadd("DiagnosticOk", [[\v.*<OK>.*]], 100)
vim.fn.matchadd("DiagnosticError", [[\v.*<NOK>.*]], 100)
vim.fn.matchadd("DiagnosticWarn", [[\v.*<TODO>.*]], 100)

vim.notify("mynotes")
