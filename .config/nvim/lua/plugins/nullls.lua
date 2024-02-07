return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        local sources = {
            null_ls.builtins.code_actions.gomodifytags,
            null_ls.builtins.code_actions.impl,
            null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.mypy,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.gofmt,
            null_ls.builtins.formatting.goimports,
            null_ls.builtins.formatting.golines,
            null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.diagnostics.golangci_lint,
            -- .with({
            --     args = { 'run', '--fast', '--fix=false', '--out-format=json' },
            -- })
        }

        null_ls.setup({
            sources = sources,
        })
    end,
}
