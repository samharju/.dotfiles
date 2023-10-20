return {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        'ray-x/lsp_signature.nvim',
        'hrsh7th/cmp-cmdline',
    },
    opts = {
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = ({
                    nvim_lsp = '[LSP]',
                    luasnip = '[LuaSnip]',
                    buffer = '[Buffer]',
                    nvim_lua = '[Lua]',
                    path = '[Path]',
                })[entry.source.name]
                return vim_item
            end
        },
        window = {
            --completion =require('cmp').config.window.bordered()
            --documentation =require('cmp').config.window.bordered()
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                -- require('cmp.config.compare').offset,
                require('cmp.config.compare').exact,
                require('cmp.config.compare').scopes,
                require('cmp.config.compare').score,
                require('cmp.config.compare').recently_used,
                require('cmp.config.compare').locality,
                require('cmp.config.compare').kind,
                -- require('cmp.config.compare').sort_text,
                require('cmp.config.compare').length,
                require('cmp.config.compare').order,
            },
        },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        sources = {
            {
                name = 'nvim_lsp',
                entry_filter = function(entry, ctx)
                    if ctx.filetype == 'python' then
                        return string.sub(entry:get_word(), 1, 2) ~= '__'
                    end
                    return true
                end
            },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer', keyword_length = 3 },
        },
        mapping = {
            ['<Tab>'] = require('cmp').mapping(function(fallback)
                if require('cmp').visible() then
                    require('cmp').select_next_item()
                elseif require('luasnip').expand_or_locally_jumpable() then
                    require('luasnip').expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = require('cmp').mapping(function(fallback)
                if require('cmp').visible() then
                    require('cmp').select_prev_item()
                elseif require('luasnip').jumpable(-1) then
                    require('luasnip').jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<CR>'] = require('cmp').mapping(function(fallback)
                if require('cmp').visible() and require('cmp').get_selected_entry() then
                    require('cmp').confirm({ select = true })
                else
                    fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
                end
            end, { 'i', 's' }),
            ['<C-e>'] = require('cmp').mapping(
                require('cmp').mapping.abort(),
                { 'i', 's' })
        }
    }
}
