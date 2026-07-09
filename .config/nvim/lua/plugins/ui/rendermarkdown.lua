return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "markdown.mynotes" },
    opts = {
        code = { language_icon = false, sign = false },
        anti_conceal = { enabled = false },
    },
}
