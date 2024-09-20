local black = {
    cmd = "black",
    stdin = true,
    stream = "stderr",
    args = { "--check", "-" },
    ignore_exitcode = true,
    parser = function(output, _, _)
        if not string.match(output, "would reformat") then return {} end
        return {
            {
                lnum = 0,
                col = 0,
                severity = vim.diagnostic.severity.HINT,
                source = "black",
                message = "this file is utter shit",
            },
        }
    end,
}

local isort = {
    cmd = "isort",
    stdin = true,
    stream = "stderr",
    args = { "--check", "--profile", "black", "-" },
    ignore_exitcode = true,
    parser = function(output, _, _)
        if output == "" then return {} end
        return {
            {
                lnum = 0,
                col = 0,
                severity = vim.diagnostic.severity.HINT,
                source = "isort",
                message = "import order is shit",
            },
        }
    end,
}

local function setup_python()
    local lint = require("lint")
    local resolve = require("samharju.venv").resolve

    local linters = {}

    if resolve("flake8") then linters[#linters + 1] = "flake8" end

    if resolve("mypy") then linters[#linters + 1] = "mypy" end

    if resolve("black") then linters[#linters + 1] = "black" end

    if resolve("isort") then linters[#linters + 1] = "isort" end

    lint.linters_by_ft.python = linters
end

return {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
        local lint = require("lint")

        lint.linters.black = black
        lint.linters.isort = isort

        lint.linters_by_ft = {
            go = { "golangcilint" },
            json = { "jq" },
        }
        setup_python()

        local lint_augroup = vim.api.nvim_create_augroup("nvim_lint_au", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                if string.match(vim.api.nvim_buf_get_name(0), "copilot:") then return end
                lint.try_lint()
            end,
        })
    end,
}
