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
                markdown = { "prettierd", "injected" },
                graphql = { "prettierd" },
                lua = { "stylua" },
                go = { "golines" },
                python = { "isort", "black" },
            },
        })

        local resolve = require("samharju.venv").resolve

        require("conform").formatters.isort = { cmd = "isort", condition = function() return resolve("isort") end }

        require("conform").formatters.black = { cmd = "black", condition = function() return resolve("black") end }
    end,
}
