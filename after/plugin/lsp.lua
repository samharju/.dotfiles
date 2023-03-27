require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = {
    -- Replace these with whatever servers you want to install
  }
})

require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  -- Create your keybindings here...
end

local lspconfig = require('lspconfig')

local get_servers = require('mason-lspconfig').get_installed_servers

for _, server_name in ipairs(get_servers()) do
  lspconfig[server_name].setup({
    on_attach = lsp_attach,
    capabilities = lsp_capabilities,
  })
end


local null_ls = require('null-ls')

null_ls.setup({
    sources = { null_ls.builtins.formatting.black }
})



