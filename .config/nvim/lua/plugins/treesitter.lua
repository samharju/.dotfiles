return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
        'windwp/nvim-ts-autotag',
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            autotag = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    node_decremental = '<S-TAB>',
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = false,
                    goto_next_start = {
                        ["]p"] = "@parameter.inner",
                    },
                    goto_previous_start = {
                        ["[p"] = "@parameter.inner",
                    }
                }
            }
        })
    end
}
