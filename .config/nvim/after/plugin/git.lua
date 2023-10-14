vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })

vim.keymap.set("n", "<leader>gs", function()
    vim.cmd("vert Git")
end, { desc = "git fugitive" })

vim.keymap.set("n", "<leader>gg", ":GitGutterLineHighlightsToggle<CR>")
vim.keymap.set("n", "<leader>gv", ":Gvdiffsplit ")
