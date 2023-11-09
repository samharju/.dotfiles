return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
        require("telescope").setup(
            {
                defaults = {
                    file_ignore_patterns = { "%.git/" },
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
            })

        -- open telescope on enter if no args given
        vim.api.nvim_create_autocmd('VimEnter', {
            callback = function()
                local arg = vim.api.nvim_eval('argv(0)')
                if arg and arg == "" then
                    require('telescope.builtin').find_files({
                        previewer = false,
                        prompt_title = vim.fn.getcwd(),
                        hidden = true
                    })
                end
            end
        })
    end,
    keys = {
        {
            '<leader>ff',
            function() require('telescope.builtin').find_files({ prompt_title = 'Files', hidden = true }) end,
            desc = 'tele find_files'
        },
        {
            '<leader>fa',
            function()
                require('telescope.builtin').find_files({
                    no_ignore = true,
                    hidden = true,
                    prompt_title = 'All files, no ignore'
                })
            end,
            desc = 'tele find_files no ignore'
        },
        { '<leader>fd', require('telescope.builtin').diagnostics,               desc = 'tele diagnostics' },
        { '<leader>fe', require('telescope.builtin').buffers,                   desc = 'tele buffers' },
        { '<leader>fg', require('telescope.builtin').git_files,                 desc = 'tele git_files' },
        { '<leader>fh', require('telescope.builtin').help_tags,                 desc = 'tele help_tags' },
        { '<leader>fk', require('telescope.builtin').keymaps,                   desc = 'tele keymaps' },
        { '<leader>fl', require('telescope.builtin').live_grep,                 desc = 'tele live_grep' },
        { '<leader>fs', require('telescope.builtin').grep_string,               desc = 'tele grep_string' },
        { '<leader>fz', require('telescope.builtin').current_buffer_fuzzy_find, desc = 'tele current_buffer_fuzzy_find' },
    }
}
