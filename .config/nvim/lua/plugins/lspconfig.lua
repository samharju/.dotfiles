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

        require('mason-lspconfig').setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name) -- default handler (optional)
                require('lspconfig')[server_name].setup {
                }
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            ['pyright'] = function()
                require('lspconfig').pyright.setup {
                    settings = {
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
            end,
            ['lua_ls'] = function()
                require('lspconfig').lua_ls.setup {
                    settings = {
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
                    }
                }
            end,
        }
    end

}
