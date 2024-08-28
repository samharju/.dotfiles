local c = require("samharju.status.components")
local git = require("samharju.status.git")
local venv = require("samharju.venv")

local M = {}

function M.update()
    local active, exists, python_version = venv.check_venv()
    if active then
        python_version = string.format("%%#StatusLineWarn#venv: %s%%*", python_version)
    elseif exists then
        python_version = string.format("%%#StatusLineError#  venv not active%%*")
    end
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
