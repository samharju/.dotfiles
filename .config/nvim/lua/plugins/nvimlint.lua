return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = { "flake8" },
            go = { "golangcilint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("nvim_lint_au", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = lint_augroup,
            callback = function() lint.try_lint() end,
        })
    end,
}
