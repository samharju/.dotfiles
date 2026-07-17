local c = require("samharju.status.components")
local M = {}

function M.update()
    local current = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

    local tabline = {}

    local tabs = vim.api.nvim_list_tabpages()
    if #tabs > 1 then
        table.insert(tabline, "%#TablineFill#")
        local ct = vim.api.nvim_get_current_tabpage()
        for _, tab in ipairs(tabs) do
            if tab == ct then
                table.insert(tabline, " ●")
            else
                table.insert(tabline, " ◌")
            end
        end
    end
    if #tabline > 0 then table.insert(tabline, " | ") end

    local tabline_str = table.concat(tabline, "")

    local n = c.harpoon_bufnames(current)
    if #n > 0 then tabline_str = tabline_str .. table.concat(n, "") end

    if #tabline_str == 0 then return "" end
    return string.format("%%#Tabline#%s%%#TabLineFill#", tabline_str)
end

return M
