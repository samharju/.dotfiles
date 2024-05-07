return {
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {
            filetypes = { "*" },
            user_default_options = { names = false },
            buftypes = {},
        },
        config = true,
    },
    {
        "stevearc/dressing.nvim",
        opts = {
            input = {
                relative = "win",
            },
        },
    },
    {
        "j-hui/fidget.nvim",
        tag = "v1.2.0",
        event = "VeryLazy",
        opts = {
            notification = {
                override_vim_notify = true, -- Automatically override vim.notify() with Fidget
            },
        },
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            {
                "<leader>z",
                function() require("zen-mode").toggle() end,
                desc = "zen mode",
            },
        },
    },
}
