-- iterate stuff via tab
vim.keymap.set('n', '<TAB>w', ':wincmd w<CR>')
vim.keymap.set('n', '<TAB>b', ':bnext<CR>')
vim.keymap.set('n', '<TAB>c', ':bp<CR>:bd#<CR>')

-- move block nicely

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- keep stuff centered
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- exit normal mode in terminal emulator
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '\"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '\"+p')
vim.keymap.set('n', '<leader>Y', '\"+Y')
vim.keymap.set('n', '<leader>P', '\"+P')

-- iterate quick- and loclist
vim.keymap.set('n', '[q', ':cprev<CR>')
vim.keymap.set('n', ']q', ':cnext<CR>')
vim.keymap.set('n', '[l', ':lprev<CR>')
vim.keymap.set('n', ']l', ':lnext<CR>')


-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>w', vim.diagnostic.open_float, { desc = 'Open diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader><leader>', function()
    vim.lsp.buf.format { async = true }
end, { desc = 'format buffer' })

vim.keymap.set('n', '<leader>;', ':b#<CR>', { desc = 'Previous buffer' })
