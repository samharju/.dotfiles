return {
    "aklt/plantuml-syntax",
    {
        "https://gitlab.com/itaranto/preview.nvim",
        version = "*",
        ft = "plantuml",
        opts = {
            render_on_write = true,
            previewers_by_ft = {
                plantuml = {
                    name = "plantuml_png",
                    renderer = {
                        type = "command",
                        opts = { cmd = { "feh" }, args = { "--keep-zoom-vp", "--auto-zoom" } },
                    },
                },
            },
            previewers = {
                plantuml_png = { args = { "-pipe", "-tpng" } },
            },
        },
    },
    {
        "mzlogin/vim-markdown-toc",
        ft = "markdown",
    },
}
