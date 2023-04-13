require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        -- Replace these with whatever servers you want to install
        'gopls',
        'lua_ls',
        'pylsp',
        'bashls',
        'tsserver',
        'ansiblels',
        'cssls',
        'cssmodules_ls',
    }
})

local luasnip = require('luasnip')
local cmp = require('cmp')

cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end
    },
    window = {
        --completion = cmp.config.window.bordered()
        --documentation = cmp.config.window.bordered()
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path',                   keyword_length = 3 },
        { name = 'buffer',                 keyword_length = 5 },
        { name = 'nvim_lsp_signature_help' },
    },
    mapping = {
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<CR>'] = function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
                cmp.confirm()
            else
                fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
            end
        end,
        ['<C-e>'] = cmp.mapping.abort()
    }
}


cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' }
    })
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
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
    vim.keymap.set('n', '<leader>g', function()
        vim.lsp.buf.format { async = true }
    end, opts)
end

local lspconfig = require('lspconfig')

local settings = {
    lua_ls = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
    pylsp = {
        plugins = {
            pycodestyle = {
                enabled = false
            },
            pyflakes = {
                enabled = false
            }
        }
    }
}

local lsp_settings = function(server)
    if settings[server] then
        return settings[server]
    end
    return {}
end

local get_servers = require('mason-lspconfig').get_installed_servers

for _, server_name in ipairs(get_servers()) do
    lspconfig[server_name].setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        settings = lsp_settings(server_name),
    })
end

require('luasnip.loaders.from_vscode').lazy_load()
require("lsp_lines").setup()

vim.keymap.set(
    "",
    "<Leader>m",
    require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
)
