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

local ls = require('luasnip')

vim.keymap.set("i", "<C-u>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)


local cmp = require('cmp')

cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                buffer = "[Buffer]",
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
        { name = 'path' },
        { name = 'buffer',  keyword_length = 3 },
    },
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif ls.expand_or_locally_jumpable() then
                ls.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif ls.jumpable(-1) then
                ls.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
                cmp.confirm({ select = true })
            else
                fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
            end
        end, { "i", "s" }),
        ['<C-e>'] = cmp.mapping(
            cmp.mapping.abort(),
            { "i", "s" })
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
end

require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})


local lspconfig = require('lspconfig')

local lsp_settings = {
    lua_ls = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
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
    -- padding = ' ',
    -- handler_opts = {
    --     border = "rounded"
    -- }

}
