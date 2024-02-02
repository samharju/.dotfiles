return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'folke/neodev.nvim',
    },
    event = 'VeryLazy',
    config = function()
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                -- Replace these with whatever servers you want to install
                'bashls',
                'docker_compose_language_service',
                'dockerls',
                'gopls',
                'lua_ls',
                'pyright',
            }
        })
        require('neodev').setup({})


        local lsp_settings = {
            lua_ls = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            quote_style = 'single'
                        }
                    }
                }
            },
            pyright = {
                python = {
                    analysis = {
                        typeCheckingMode = 'basic',
                        autoSearchPaths = true,
                        diagnosticMode = 'workspace',
                        useLibraryCodeForTypes = true,
                        exclude = { 'venv' },
                    }
                }
            }
        }


        for _, server_name in ipairs(require('mason-lspconfig').get_installed_servers()) do
            local s = {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            }
            if lsp_settings[server_name] then
                s.settings = lsp_settings[server_name]
            end
            require('lspconfig')[server_name].setup(s)
        end

    end

}
