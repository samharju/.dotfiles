local M = {}

---@param buf? number
function M.active_lsps(buf)
    if buf == nil then buf = 0 end
    local active = vim.lsp.get_clients({ bufnr = buf })
    if #active == 0 then return "" end

    local out = {}
    for _, lsp in ipairs(active) do
        if lsp.name == "GitHub Copilot" then
            table.insert(out, "ghc")
        else
            table.insert(out, lsp.name)
        end
    end

    return table.concat(out, " ")
end

---@param buf? number
function M.formatters(buf)
    if buf == nil then buf = 0 end
    local ok, conform = pcall(require, "conform")
    if not ok then return "" end

    local active = conform.list_formatters(buf)
    if #active == 0 then return "" end

    local out = {}
    for _, formatter in ipairs(active) do
        if formatter.available then table.insert(out, formatter.name) end
    end

    return table.concat(out, " ")
end

---@param buf? number
function M.lint_progress(buf)
    if buf == nil then buf = 0 end
    local ok, lint = pcall(require, "lint")
    if not ok then return "" end

    local linters = lint.get_running(buf)
    if #linters == 0 then return "" end
    return "󱉶 " .. table.concat(linters, ", ")
end

---@param buf? number
function M.diagnostics(buf)
    if buf == nil then buf = 0 end
    local errors = vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
    if #errors > 0 then return string.format("%%#StatusLineError# %s%%*", #errors) end
    local warnings = vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
    if #warnings > 0 then return string.format("%%#StatusLineWarn# %s%%*", #warnings) end
    local rest = vim.diagnostic.get(buf, { severity = { max = vim.diagnostic.severity.INFO } })
    if #rest > 0 then return string.format("%%#StatusLineInfo# %s%%*", #rest) end
    return ""
end

---@param parts string[]
---@param sep string
function M.join(parts, sep)
    local out = {}

    for _, part in ipairs(parts) do
        if part ~= "" then table.insert(out, part) end
    end

    return table.concat(out, sep)
end

return M
