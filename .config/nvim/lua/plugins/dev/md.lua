return {
    "aklt/plantuml-syntax",
    {
        "https://gitlab.com/itaranto/plantuml.nvim",
        version = "*",
        config = function() require("plantuml").setup() end,
    },
    {
        "mzlogin/vim-markdown-toc",
        ft = "markdown",
    },
}
