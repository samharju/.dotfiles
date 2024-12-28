local M = {}

local function split(path)
    local parts = {}
    for part in string.gmatch(path, "[^/]+") do
        table.insert(parts, part)
    end
    return parts
end

local function expand(paths)
    local counts = {}
    for _, name in ipairs(paths) do
        if counts[name.basename] == nil then counts[name.basename] = 0 end
        counts[name.basename] = counts[name.basename] + 1
    end

    local val = {}
    for _, path in ipairs(paths) do
        local item = { display = path.basename, fname = path.fname }
        if counts[path.basename] > 1 then
            -- use last 2 parts of the path
            local parts = split(path.fname)
            item.display = parts[#parts - 1] .. "/" .. parts[#parts]
        end
        table.insert(val, item)
    end

    return val
end

local function harpoons()
    local val = {}
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then return val end

    local list = harpoon:list().items
    if #list == 0 then return val end

    for _, harp in ipairs(list) do
        table.insert(val, { fname = harp.value, basename = vim.fn.fnamemodify(harp.value, ":t") })
    end

    return expand(val)
end

function M.update()
    local current = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

    local val = {}
    for _, harp in ipairs(harpoons()) do
        if harp.fname == current then
            table.insert(val, string.format("%%#TablineSel# %s ", harp.display))
        else
            table.insert(val, string.format("%%#Comment# %s ", harp.display))
        end
    end

    if #val == 0 then return "" end

    return string.format("%%#Tabline#%s%%*", table.concat(val, ""))
end

return M
