-- iterate stuff via tab
vim.keymap.set("n", "<TAB>w", ":wincmd w<CR>")
vim.keymap.set("n", "<TAB>b", ":bnext<CR>")
vim.keymap.set("n", "<TAB>c", ":bp<CR>:bd#<CR>")

-- move block nicely

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep stuff centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- exit normal mode in terminal emulator
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>P", "\"+P")


-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>w', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>m', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader><leader>', function()
    vim.lsp.buf.format { async = true }
end, { desc = "format buffer" })

vim.keymap.set("n", '<leader>;', ":b#<CR>")
-- local grp = vim.api.nvim_create_augroup("Prewrites", { clear = true })

--vim.api.nvim_create_autocmd('BufWritePre', {
--    callback = function()
--        vim.lsp.buf.format()
--    end,
--    group = grp,
--})
