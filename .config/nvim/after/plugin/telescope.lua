require('telescope').setup {
    pickers = {
        find_files = {
            theme = "dropdown",
        },
        buffers = {
            theme = "dropdown"
        },
        current_buffer_fuzzy_find = {
            theme = "dropdown"
        }
    },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fe', builtin.buffers, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
