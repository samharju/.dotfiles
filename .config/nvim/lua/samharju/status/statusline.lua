local c = require("samharju.status.components")
local git = require("samharju.status.git")
local resolve = require("samharju.venv")

local M = {}

function M.update()
    local venv, python_version = resolve("virtualenv")
    if venv then python_version = string.format("%%#StatusLineWarn#%s%%*", python_version) end
    local branch, diff = git.update()
    local diag = c.diagnostics()
    local f = c.formatters()
    if f ~= "" then f = string.format("%%#StatusLineComment#%s%%*", f) end

    local status_left_parts = {
        branch,
        diff,
        diag,
        c.lint_progress(),
    }

    local status_right_parts = {
        python_version,
        f,
        c.active_lsps(),
        vim.bo.filetype,
        "%-12.(%l,%v%) %P",
    }

    local status_parts = {
        "%<",
        c.join(status_left_parts, "  "),
        "%=",
        c.join(status_right_parts, "  "),
    }

    return c.join(status_parts, "")
end

return M
