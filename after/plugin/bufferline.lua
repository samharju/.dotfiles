require("bufferline").setup{}


vim.keymap.set("n", "<leader>[", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader>]", ":BufferLineCycleNext<CR>")
