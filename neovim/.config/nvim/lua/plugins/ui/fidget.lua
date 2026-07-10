return {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
        integration = {
            ["nvim-tree"] = {
                enable = false, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
            },
        },
    },
}
