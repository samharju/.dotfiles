return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader><leader>",
            function() require("conform").format({ async = true, lsp_fallback = true }) end,
            desc = "Format buffer",
        },
    },
    config = function()
        require("conform").setup({
            -- Define your formatters
            formatters_by_ft = {
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescriptreact = { "prettierd" },
                svelte = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                json = { "prettierd" },
                yaml = { "prettierd" },
                markdown = { "prettierd" },
                graphql = { "prettierd" },
                lua = { "stylua" },
                go = { "goimports", "gofmt", "golines" },
                python = { "isort", "black" },
            },
        })

        local resolve = require("samharju.venv").resolve

        local iok, ipath = resolve("isort")
        require("conform").formatters.isort = { cmd = ipath, condition = function() return iok end }

        local bok, bpath = resolve("black")
        require("conform").formatters.black = { cmd = bpath, condition = function() return bok end }
    end,
}
