local M = {}

local function harpoons()
    local val = {}
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then return val end

    local list = harpoon:list().items
    if #list == 0 then return val end

    for _, harp in ipairs(list) do
        table.insert(val, harp.value)
    end

    return val
end

function M.update()
    local current = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

    local val = {}
    for _, harp in ipairs(harpoons()) do
        local repr = vim.fn.fnamemodify(harp, ":t")
        if harp == current then
            table.insert(val, string.format("%%#TablineSel#%s%%*", repr))
        else
            table.insert(val, string.format("%%#Comment#%s", repr))
        end
    end

    return string.format("%%#Tabline#%s%%*", table.concat(val, " "))
end

return M
