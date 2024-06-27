local M = {}

local function stl_hl(name, hl, stl)
    vim.api.nvim_set_hl(0, name, { fg = hl.fg, italic = hl.italic, bg = stl.bg, reverse = stl.reverse })
end

function M.setup(group)
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        group = group,
        callback = function()
            local stl_default = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
            local hl_added = vim.api.nvim_get_hl(0, { name = "Added", link = false })
            local hl_changed = vim.api.nvim_get_hl(0, { name = "Changed", link = false })
            local hl_removed = vim.api.nvim_get_hl(0, { name = "Removed", link = false })

            stl_hl("StatusLineAdded", hl_added, stl_default)
            stl_hl("StatusLineChanged", hl_changed, stl_default)
            stl_hl("StatusLineRemoved", hl_removed, stl_default)

            local hl_diagerr = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false })
            local hl_diagwarn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
            local hl_diaginfo = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false })

            stl_hl("StatusLineError", hl_diagerr, stl_default)
            stl_hl("StatusLineWarn", hl_diagwarn, stl_default)
            stl_hl("StatusLineInfo", hl_diaginfo, stl_default)

            local hl_comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })

            stl_hl("StatusLineComment", hl_comment, stl_default)
        end,
    })
end

return M
