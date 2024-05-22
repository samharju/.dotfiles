local function get_root(files)
    local f = vim.fs.find(files, {
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        stop = vim.loop.os_homedir(),
        upward = true,
    })[1]

    if f then return vim.fs.dirname(f) end

    return vim.loop.cwd()
end

local black = {
    cmd = "black",
    stdin = true,
    stream = "stderr",
    args = { "--check", "-" },
    ignore_exitcode = true,
    cwd = get_root({ "pyproject.toml", "setup.py", "setup.cfg", ".git" }),
    parser = function(output, _, _)
        local msg = vim.fn.split(output, "\n")[1]
        if not string.match(msg, "would reformat") then return {} end
        return {
            {
                lnum = 0,
                col = 0,
                severity = vim.diagnostic.severity.INFO,
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
    cwd = get_root({ "pyproject.toml", "setup.py", "setup.cfg", ".git" }),
    parser = function(output, _, _)
        local msg = vim.fn.split(output, "\n")[1]
        if not string.match(msg, "ERROR:") then return {} end
        return {
            {
                lnum = 1,
                col = 0,
                severity = vim.diagnostic.severity.INFO,
                source = "isort",
                message = "import order is shit",
            },
        }
    end,
}

local function available_of(linters)
    local lint = {}

    for _, value in ipairs(linters) do
        if vim.fn.executable(value) == 1 then table.insert(lint, value) end
    end

    return lint
end

return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")

        lint.linters.black = black
        lint.linters.isort = isort

        lint.linters_by_ft = {
            python = available_of({ "flake8", "black", "isort", "mypy" }),
            go = { "golangcilint" },
            json = { "jq" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("nvim_lint_au", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = lint_augroup,
            callback = function()
                if string.match(vim.api.nvim_buf_get_name(0), "copilot:") then return end
                lint.try_lint()
            end,
        })
    end,
}
