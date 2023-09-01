require('telescope').setup {
    defaults = {
        mappings = {
            n = {
                ['x'] = require('telescope.actions').delete_buffer
            }
        }
    },
    pickers = {
        find_files = {
            theme = "dropdown",
            results_title = false,
            previewer = false,
            hidden = true,
        },
        buffers = {
            theme = "dropdown",
            previewer = false,
            results_title = false
        },
        current_buffer_fuzzy_find = {
            theme = "ivy",
            previewer = false,
            results_title = false,
        }
    },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, { desc = "tele current_buffer_fuzzy_find" })
vim.keymap.set('n', '<leader>fa', function() builtin.find_files({ prompt_title = "Files" }) end,
    { desc = "tele find_files" })
vim.keymap.set('n', '<leader>fz',
    function() builtin.find_files({ no_ignore = true, prompt_title = "All files, no ignore" }) end,
    { desc = "tele find_files no ignore" })
vim.keymap.set('n', '<leader>fe', builtin.buffers, { desc = "tele buffers" })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "tele diagnostics" })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "tele git_files" })
vim.keymap.set('n', '<leader>fl', builtin.live_grep, { desc = "tele live_grep" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "tele help_tags" })
vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = "tele grep_string" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "tele keymaps" })

vim.api.nvim_create_augroup('startup', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    group = 'startup',
    pattern = '*',
    callback = function()
        -- Open file browser if argument is a folder
        local arg = vim.api.nvim_eval('argv(0)')
        if arg and (vim.fn.isdirectory(arg) ~= 0 or arg == "") then
            local cwd = vim.fn.getcwd()
            vim.defer_fn(function()
                builtin.find_files({
                    previewer = false,
                    hidden = false,
                    theme = 'vertical',
                    layout_strategy = 'center',
                    prompt_title = cwd
                })
            end, 10)
        end
    end
})
