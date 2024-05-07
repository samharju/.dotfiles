local git = require("samharju.status.git")

local M = {}

local function active_lsps()
    local active = vim.lsp.get_active_clients({ bufnr = 0 })
    if #active == 0 then return "" end

    local out = {}
    for _, lsp in ipairs(active) do
        table.insert(out, lsp.name)
    end

    return "[ls: " .. table.concat(out, " ") .. "]"
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

    return "{f: " .. table.concat(out, " ") .. "}"
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
    if #errors > 0 then return string.format("%%#DiagnosticError# %s%%*", #errors) end
    local warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if #warnings > 0 then return string.format("%%#DiagnosticWarn# %s%%*", #warnings) end
    local rest = vim.diagnostic.get(0)
    if #rest > 0 then return string.format("%%#DiagnosticInfo# %s%%*", #rest) end
    return ""
end

function M.update()
    local status_parts = {
        "%<",
        git.update(),
        "%=",
        lint_progress(),
        diagnostics(),
        formatters(),
        active_lsps(),
        "%=",
        "%y",
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
