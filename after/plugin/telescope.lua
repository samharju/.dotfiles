local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>af', builtin.find_files, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>l', builtin.live_grep, {})
vim.keymap.set('n', '<leader>s', function()
    local input_string = vim.fn.input("Grep > ")
    if input_string == '' then
        input_string = vim.fn.expand('<cword>')
    end
    builtin.grep_string({ search = input_string })
end)
