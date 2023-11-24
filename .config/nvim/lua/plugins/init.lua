return {
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    {
        'stevearc/dressing.nvim',
        opts = {
            select = { enabled = false }
        }
    },
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
            scope = { show_start = false, show_end = false },
            indent = { tab_char = "▎" }
        }
    },
    {
        'folke/zen-mode.nvim',
        keys = {
            { '<leader>z', function() require('zen-mode').toggle() end, desc = 'zen mode' }
        }
    },
    {
        'folke/flash.nvim',
        keys = {
            { 's', function() require('flash').jump() end, desc = 'flash search' }
        }
    },
    {
        'NvChad/nvim-colorizer.lua',
        opts = {
            filetypes = { '*' },
            user_default_options = { names = false },
            buftypes = {}
        },
        config = true
    },
    {
        'mbbill/undotree',
        keys = { { '<leader>u', vim.cmd.UndotreeToggle, desc = 'UndotreeToggle' } }
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
        keys = {
            { '<leader>gs', function() vim.cmd('vert Git') end, desc = 'git fugitive' },
            { '<leader>gv', ':Gvdiffsplit ',                    desc = 'git diff split' }
        }
    },
    {
        'airblade/vim-gitgutter',
        lazy = false,
        keys = { { '<leader>gg', ':GitGutterLineHighlightsToggle<CR>', desc = 'toggle gutter', silent = true } }
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
