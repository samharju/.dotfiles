return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        defaults = {
            mappings = {
                n = {
                    ['x'] = require('telescope.actions').delete_buffer
                }
            }
        },
        pickers = {
            find_files = {
                theme = 'dropdown',
                results_title = false,
                previewer = false,
            },
            buffers = {
                theme = 'dropdown',
                previewer = false,
                results_title = false
            },
            current_buffer_fuzzy_find = {
                theme = 'ivy',
                previewer = false,
                results_title = false,
            }
        }
    },
    keys = {
        { '<leader>ff', require('telescope.builtin').current_buffer_fuzzy_find, desc = 'tele current_buffer_fuzzy_find' },
        { '<leader>fa', function() require('telescope.builtin').find_files({ prompt_title = 'Files' }) end,  desc = 'tele find_files' },
        { '<leader>fz', function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true, prompt_title = 'All files, no ignore' }) end, desc = 'tele find_files no ignore' },
        { '<leader>fe', require('telescope.builtin').buffers,  desc = 'tele buffers' },
        { '<leader>fd', require('telescope.builtin').diagnostics, desc = 'tele diagnostics' },
        { '<leader>fg', require('telescope.builtin').git_files,  desc = 'tele git_files' },
        { '<leader>fl', require('telescope.builtin').live_grep,  desc = 'tele live_grep' },
        { '<leader>fh', require('telescope.builtin').help_tags,  desc = 'tele help_tags' },
        { '<leader>fs', require('telescope.builtin').grep_string,  desc = 'tele grep_string' },
        { '<leader>fk', require('telescope.builtin').keymaps,  desc = 'tele keymaps' },
    }
}

