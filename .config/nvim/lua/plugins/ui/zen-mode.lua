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
}
