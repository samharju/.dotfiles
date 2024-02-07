local function active_lsps()
    local out = ""
    for _, value in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if string.len(out) == 0 then
            out = value.name
        else
            out = out .. ", " .. value.name
        end
    end
    return out
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "AndreM222/copilot-lualine",
    },
    opts = {
        extensions = { "fugitive", "nvim-tree", "lazy", "quickfix", "mason" },
        options = {
            globalstatus = true,
            refresh = {
                statusline = 200,
            },
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
        tabline = {},
        winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { "filename", path = 1 }, "diagnostics" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { "filename", path = 1 }, "diagnostics" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", { "filename", path = 1 } },
            lualine_c = { "diff", "copilot" },
            lualine_x = { "lsp_progress" },
            lualine_y = { active_lsps, "filetype" },
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
    },
}
