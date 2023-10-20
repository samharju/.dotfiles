return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
        'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    config = function()
        local configs = require('nvim-treesitter.configs')

        configs.setup({
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
        })
    end
}
