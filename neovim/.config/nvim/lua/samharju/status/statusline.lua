local c = require("samharju.status.components")
local git = require("samharju.status.git")

local M = {}

local sepleft = string.format("%%#StatusLineComment#%s%%*", "  ")
local sepright = string.format("%%#StatusLineComment#%s%%*", "  ")

function M.update()
    if vim.bo.filetype == "fugitive" or vim.bo.filetype == "git" then return git.last_commit end

    local buf = vim.api.nvim_get_current_buf()
    local branch, diff = git.update(buf)

    local git_status = branch
    if diff ~= "" and diff ~= nil then git_status = branch .. " " .. diff end

    local f = c.formatters()
    if f ~= "" then f = string.format("%%#StatusLineComment#%s%%*", f) end

    local left = c.join({
        git_status,
        c.ollama(),
        c.lint_progress(buf),
        c.dap_status(),
    }, sepleft)

    local right = c.join({
        f,
        c.active_lsps(),
        c.filetypeicon(),
        c.python_version(),
        "%-8.(%l,%v%) %P",
    }, sepright)

    local status_parts = {
        left,
        "%<%=",
        right,
    }

    return c.join(status_parts, "")
end

return M
