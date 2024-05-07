return {
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {
            filetypes = { "*" },
            user_default_options = { names = false },
            buftypes = {},
        },
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
        opts = {
            window = {
                backdrop = 0.9,
                width = 120,
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = true,
                    showcmd = true,
                    laststatus = 0,
                },
                tmux = { enabled = true },
            },
        },
    },
}
