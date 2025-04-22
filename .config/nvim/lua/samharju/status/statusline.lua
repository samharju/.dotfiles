local c = require("samharju.status.components")
local git = require("samharju.status.git")

local M = {}

local sepleft = string.format("%%#StatusLineComment#%s%%*", "  ")
local sepright = string.format("%%#StatusLineComment#%s%%*", "  ")

function M.update()
    local branch, diff = git.update()

    local gst = branch
    if diff ~= "" and diff ~= nil then gst = branch .. " " .. diff end

    local f = c.formatters()
    if f ~= "" then f = string.format("%%#StatusLineComment#%s%%*", f) end

    local left = {
        gst,
        c.harpoons(),
        vim.bo.buflisted and "%f" or "",
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
