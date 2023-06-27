require("zen-mode").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}

vim.keymap.set("n", "<leader>z", require("zen-mode").toggle)
