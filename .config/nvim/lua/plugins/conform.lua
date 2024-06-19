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

        local resolve = require("samharju.venv")

        local ok, path = resolve("isort")
        require("conform").formatters.isort = { cmd = path, condition = function() return ok end }

        ok, path = resolve("black")
        require("conform").formatters.black = { cmd = path, condition = function() return ok end }
    end,
}
