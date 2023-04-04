vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

vim.keymap.set("n", "<leader>gg", ":GitGutterLineHighlightsToggle<CR>")

vim.keymap.set("n", "<leader>z", require("zen-mode").toggle)
