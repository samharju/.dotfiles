local c = require("samharju.status.components")
local git = require("samharju.status.git")

local M = {}

local sepleft = string.format("%%#StatusLineComment#%s%%*", "  ")
local sepright = string.format("%%#StatusLineComment#%s%%*", "  ")

function M.update()
    local buf = vim.api.nvim_get_current_buf()
    local branch, diff = git.update(buf)

    local gst = branch
    if diff ~= "" and diff ~= nil then gst = branch .. " " .. diff end

    local f = c.formatters()
    if f ~= "" then f = string.format("%%#StatusLineComment#%s%%*", f) end

    local left = {
        gst,
        vim.bo.buflisted and "%f" or "",
        c.diagnostics(buf),
        c.ollama(),
        c.lint_progress(buf),
    }

    local right = {
        f,
        c.active_lsps(),
        c.python_version() or vim.bo.filetype,
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
