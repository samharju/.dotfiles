vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_preview_win_floating = 0

vim.keymap.set("n", "<BS>g", ":GitGutterLineHighlightsToggle<CR>")
vim.keymap.set("n", "<BS>d", ":GitGutterNextHunk<CR>")
vim.keymap.set("n", "<BS>a", ":GitGutterPrevHunk<CR>")
vim.keymap.set("n", "<BS>s", ":GitGutterStageHunk<CR>")
vim.keymap.set("n", "<BS>x", ":GitGutterUndoHunk<CR>")
vim.keymap.set("n", "<BS>w", ":GitGutterPreviewHunk<CR>")
