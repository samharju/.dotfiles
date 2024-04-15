local function active_lsps()
    local active = vim.lsp.get_active_clients({ bufnr = 0 })
    if #active == 0 then return "" end

    local out = {}
    for _, lsp in ipairs(active) do
        table.insert(out, lsp.name)
    end

    return "󰰎 " .. table.concat(out, " ")
end

local function formatters()
    local ok, conform = pcall(require, "conform")
    if not ok then return "" end

    return function()
        local active = conform.list_formatters(0)
        if #active == 0 then return "" end

        local out = {}
        for _, formatter in ipairs(active) do
            if formatter.available then table.insert(out, formatter.name) end
        end

        return "󰯼 " .. table.concat(out, " ")
    end
end

local function lint_progress()
    local ok, lint = pcall(require, "lint")
    if not ok then return "" end

    return function()
        local linters = lint.get_running(0)
        if #linters == 0 then return "" end
        return "󱉶 " .. table.concat(linters, ", ")
    end
end

local function parse_git_diff()
    local added = 0
    local changed = 0
    local removed = 0

    local cmd = string.format([[git -C %s --no-pager diff --unified=0]], vim.loop.cwd())
    local out = vim.fn.system(cmd)

    for line in string.gmatch(out, "[^\n]+") do
        if line:match([[^@@]]) then
            local hunk_removed, hunk_added = line:match([[^@@ %-%d+,?(%d*) %+%d+,?(%d*) @@]])

            if hunk_added == "" then
                hunk_added = 1
            else
                hunk_added = tonumber(hunk_added)
            end

            if hunk_removed == "" then
                hunk_removed = 1
            else
                hunk_removed = tonumber(hunk_removed)
            end

            if hunk_removed == 0 and hunk_added > 0 then
                added = added + hunk_added
            elseif hunk_added == 0 and hunk_removed > 0 then
                removed = removed + hunk_removed
            else
                local min = math.min(hunk_removed, hunk_added)

                changed = changed + min
                added = added + hunk_added - min
                removed = removed + hunk_removed - min
            end
        end
    end

    return { added = added, changed = changed, removed = removed }
end

local diffstat = ""
local function diff() return diffstat end

local grp = vim.api.nvim_create_augroup("samharju_lualine_diff", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    pattern = "*",
    group = grp,
    callback = function()
        local diff = parse_git_diff()

        local output = ""

        if diff.added > 0 then output = output .. "%#diffAdded#+" .. diff.added end
        if output ~= "" then output = output .. " " end
        if diff.changed > 0 then output = output .. "%#diffChanged#~" .. diff.changed end
        if output ~= "" then output = output .. " " end
        if diff.removed > 0 then output = output .. "%#diffRemoved#-" .. diff.removed end

        diffstat = output
    end,
})

--- Lualine configuration
return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            extensions = { "fugitive", "nvim-tree", "lazy", "quickfix", "mason" },
            options = {
                globalstatus = true,
                refresh = {
                    statusline = 100,
                },
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            tabline = {},
            winbar = {
                lualine_a = {},
                lualine_b = { { "filename", path = 1 } },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = { diff, "diagnostics", lint_progress() },
                lualine_x = {},
                lualine_y = { formatters(), active_lsps, "filetype", "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        })
    end,
}
