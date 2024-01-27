return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup(
            {
                defaults = {
                    file_ignore_patterns = { '%.git/' },
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
                if arg and arg == '' then
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
        { '<leader>fd', function() require('telescope.builtin').diagnostics() end,                desc = 'tele diagnostics' },
        { '<leader>fe', function() require('telescope.builtin').buffers() end,                    desc = 'tele buffers' },
        { '<leader>fg', function() require('telescope.builtin').git_status() end,                 desc = 'tele git_status' },
        { '<leader>fh', function() require('telescope.builtin').help_tags() end,                  desc = 'tele help_tags' },
        { '<leader>fk', function() require('telescope.builtin').keymaps() end,                    desc = 'tele keymaps' },
        { '<leader>fl', function() require('telescope.builtin').live_grep() end,                  desc = 'tele live_grep' },
        { '<leader>fs', function() require('telescope.builtin').grep_string() end,                desc = 'tele grep_string' },
        { '<leader>fz', function() require('telescope.builtin').current_buffer_fuzzy_find() end,  desc = 'tele current_buffer_fuzzy_find' },
        { '<leader>fi', function() require('telescope.builtin').highlights() end,                 desc = 'tele highlights' },
    }
}
