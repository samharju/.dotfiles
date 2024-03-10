return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader><leader>",
            function() require("conform").format({ async = true, lsp_fallback = true }) end,
            mode = "",
            desc = "Format buffer",
        },
    },
    -- Everything in opts will be passed to setup()
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            go = { "goimports", "gofmt", "golines" },
            ["_"] = { { "prettierd", "prettier" } },
        },
    },
}
