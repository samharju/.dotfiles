return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'folke/neodev.nvim',
        'ray-x/lsp_signature.nvim',
    },
    init = function()
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                -- Replace these with whatever servers you want to install
                'gopls',
                'lua_ls',
                'bashls',
                'tsserver',
                'ansiblels',
                'cssls',
                'cssmodules_ls',
                'pyright',
            }
        })

        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_attach = function(_client, bufnr)
            -- Create your keybindings here...
            --
            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        end

        require('neodev').setup({})

        local lspconfig = require('lspconfig')
        local lsp_settings = {
            lua_ls = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            },
            pyright = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = 'openFilesOnly',
                        diagnosticSeverityOverrides = {
                            reportOptionalMemberAccess = 'information',
                            reportGeneralTypeIssues = 'information'
                        }
                    }
                }
            }
        }


        local get_servers = require('mason-lspconfig').get_installed_servers

        for _, server_name in ipairs(get_servers()) do
            local s = {
                on_attach = lsp_attach,
                capabilities = lsp_capabilities,
            }
            if lsp_settings[server_name] then
                s.settings = lsp_settings[server_name]
            end
            lspconfig[server_name].setup(s)
        end


        require('lsp_signature').setup {
            bind = true,
            fix_pos = false,
            hint_enable = false,
            max_width = 120,
        }
    end

}
