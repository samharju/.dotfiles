return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "markdown.mynotes" },
    opts = {
        code = { style = "normal", disable_background = true, border = "none" },
        -- anti_conceal = { enabled = true },
    },
}
