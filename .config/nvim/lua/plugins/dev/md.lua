return {
    "aklt/plantuml-syntax",
    {
        "https://gitlab.com/itaranto/plantuml.nvim",
        version = "*",
        ft = "plantuml",
        config = function() require("plantuml").setup() end,
    },
    {
        "mzlogin/vim-markdown-toc",
        ft = "markdown",
    },
}
