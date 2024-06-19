local git = require("samharju.status.git")
local resolve = require("samharju.venv")

local M = {}

local function active_lsps()
    local active = vim.lsp.get_clients({ bufnr = 0 })
    if #active == 0 then return "" end

    local out = {}
    for _, lsp in ipairs(active) do
        table.insert(out, lsp.name)
    end

    return "(" .. table.concat(out, " ") .. ")"
end

local function formatters()
    local ok, conform = pcall(require, "conform")
    if not ok then return "" end

    local active = conform.list_formatters(0)
    if #active == 0 then return "" end

    local out = {}
    for _, formatter in ipairs(active) do
        if formatter.available then table.insert(out, formatter.name) end
    end

    return "{" .. table.concat(out, " ") .. "}"
end

local function lint_progress()
    local ok, lint = pcall(require, "lint")
    if not ok then return "" end

    local linters = lint.get_running(0)
    if #linters == 0 then return "" end
    return "󱉶 " .. table.concat(linters, ", ")
end

local function diagnostics()
    local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #errors > 0 then return string.format("%%#StatusLineError# %s%%*", #errors) end
    local warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if #warnings > 0 then return string.format("%%#StatusLineWarn# %s%%*", #warnings) end
    local rest = vim.diagnostic.get(0)
    if #rest > 0 then return string.format("%%#StatusLineInfo# %s%%*", #rest) end
    return ""
end

function M.update()
    local venv, version = resolve("virtualenv")
    if venv then version = string.format("%%#StatusLineWarn#%s%%*", version) end
    local status_parts = {
        "%<",
        git.update(),
        "%=",
        lint_progress(),
        diagnostics(),
        formatters(),
        active_lsps(),
        "%y",
        version,
        "%=",
        "%-14.(%l,%v%)",
        "%P",
    }

    local output = {}

    for _, part in ipairs(status_parts) do
        if part ~= "" then table.insert(output, part) end
    end

    return table.concat(output, " ")
end

return M
