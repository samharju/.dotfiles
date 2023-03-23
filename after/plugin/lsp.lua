local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
  lsp.buffer_autoformat()
end)

lsp.setup()
