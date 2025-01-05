local c = require("samharju.status.components")
local git = require("samharju.status.git")

local M = {}

local sepleft = string.format("%%#StatusLineComment#%s%%*", "  ")
local sepright = string.format("%%#StatusLineComment#%s%%*", "  ")

function M.update()
    local branch, diff = git.update()
    local diag = c.diagnostics()
    local f = c.formatters()
    if f ~= "" then f = string.format("%%#StatusLineComment#%s%%*", f) end

    local left = {
        branch,
        diff,
        c.harpoons(),
        "%f",
        diag,
        c.lint_progress(),
    }

    local right = {
        c.python_version(),
        c.active_lsps(),
        vim.bo.filetype,
        "%-8.(%l,%v%) %P",
    }

    local status_parts = {
        "%<",
        c.join(left, sepleft),
        "%=",
        c.join(right, sepright),
    }

    return c.join(status_parts, "")
end

return M
