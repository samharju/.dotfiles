local venv = require("samharju.venv")

local M = {}

local ctr = 0
local ollama_str = ""

local function ttl(timestamp)
    local year, mon, day, h, m, s = timestamp:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+).*")
    return math.floor((os.time({ year = year, month = mon, day = day, hour = h, min = m, sec = s }) - os.time()) / 60)
end

function M.ollama()
    if os.time() - ctr > 10 then
        ctr = os.time()
        vim.system({ "curl", "-s", "http://10.0.2.2:11434/api/ps" }, { text = true }, function(out)
            if out.code ~= 0 then return end
            local str = {}
            local d = vim.json.decode(out.stdout)
            for _, model in ipairs(d.models) do
                table.insert(
                    str,
                    string.format(
                        "%%#StatusLineComment#%s %s%%%% GPU (%smin)%%*",
                        model.name,
                        math.floor(model.size_vram * 100 / model.size),
                        ttl(model.expires_at)
                    )
                )
            end

            ollama_str = table.concat(str, ",")
        end)
    end

    return ollama_str .. (vim.g.model_churning or "")
end

function M.python_version()
    if vim.bo.filetype ~= "python" then return "" end

    local active, exists, pyv = venv.check_venv()
    if active then
        pyv = string.format("%%#StatusLineWarn#venv: %s%%*", pyv)
    elseif exists then
        pyv = string.format("%%#StatusLineError# venv%%*")
    end
    return pyv
end

function M.harpoons()
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then return "" end

    local list = harpoon:list().items
    if #list == 0 then return "" end

    local val = {}
    local c = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    for _, h in ipairs(list) do
        if h.value == c then
            table.insert(val, "●")
        else
            table.insert(val, "%#StatusLineComment#◌%*")
        end
    end

    return table.concat(val, "")
end

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
