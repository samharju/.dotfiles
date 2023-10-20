return {
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',

    {
        'hrsh7th/cmp-cmdline',
        event = 'CmdlineEnter',
        config = function()
            local cmp = require('cmp')
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
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            scope = { show_start = false, show_end = false } }
    },
    {
        'folke/zen-mode.nvim',
        config = function()
            vim.keymap.set('n', '<leader>z', require('zen-mode').toggle, { desc = 'zen mode' })
        end,
    },
    {
        'folke/flash.nvim',
        config = function()
            vim.keymap.set('n', 's', require('flash').jump, { desc = 'init flash' })
        end,
    },
    {
        'NvChad/nvim-colorizer.lua',
        config = true
    },
    {
        'mbbill/undotree',
        keys = { { '<leader>u', vim.cmd.UndotreeToggle, desc = 'UndotreeToggle' } }
    },
    {
        'tpope/vim-fugitive',
        keys = {
            { '<leader>gs', function() vim.cmd('vert Git') end, desc = 'git fugitive' },
            { '<leader>gv', ':Gvdiffsplit ',                    desc = 'git diff split' }
        }
    },
    {
        'airblade/vim-gitgutter',
        lazy = false,
        keys = { { '<leader>gg', ':GitGutterLineHighlightsToggle<CR>', desc = 'toggle gutter' } }
    },
    {
        'terrortylor/nvim-comment',
        config = function() require('nvim_comment').setup() end
    },
    {
        'mzlogin/vim-markdown-toc',
        ft = 'markdown'
    },
    {
        'eandrju/cellular-automaton.nvim',
        keys = {
            { '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>' },
            { '<leader>fts', '<cmd>CellularAutomaton game_of_life<CR>' },
        }
    }
}
