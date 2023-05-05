require('telescope').setup {
    defaults = {
    },
    pickers = {
        find_files = {
            theme = "ivy",
        },
        buffers = {
            theme = "ivy"
        },
        current_buffer_fuzzy_find = {
            theme = "ivy"
        }
    },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fz', function() builtin.find_files({ no_ignore = true }) end, {})
vim.keymap.set('n', '<leader>fe', builtin.buffers, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
