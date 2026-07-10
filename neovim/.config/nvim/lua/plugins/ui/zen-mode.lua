return {
    "folke/zen-mode.nvim",
    keys = {
        {
            "<leader>z",
            function() require("zen-mode").toggle() end,
            desc = "zen mode",
        },
    },
    opts = {
        plugins = {
            options = {
                enabled = true,
                laststatus = 0,
            },
            tmux = { enabled = true },
        },
    },
}
