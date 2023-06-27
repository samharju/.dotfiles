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
            theme = "ivy",
        },
        buffers = {
            theme = "dropdown"
        },
        current_buffer_fuzzy_find = {
            theme = "ivy"
        }
    },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fa', function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>fz', function() builtin.find_files({ no_ignore = true, hidden = true }) end, {})
vim.keymap.set('n', '<leader>fe', function() builtin.buffers({ previewer = false }) end, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})

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
                builtin.find_files({ previewer = false, layout_strategy = 'center', prompt_title = cwd })
            end, 10)
        end
    end
})
