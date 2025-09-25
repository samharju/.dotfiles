return {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
        notification = {
            override_vim_notify = true, -- Automatically override vim.notify() with Fidget
        },
        integration = {
            ["nvim-tree"] = {
                enable = false, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
            },
        },
    },
}
