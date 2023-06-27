require('lualine').setup {
    options = {
        globalstatus = true,
        refresh = {
            statusline = 200,
        }
    },
    tabline = {
    },
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path= 1 }, 'diagnostics' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', { 'filename', path = 1 } },
        lualine_c = { 'diff' },
        lualine_x = { 'progress', 'filetype' },
        lualine_y = {},
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
}

vim.keymap.set("n", "<leader>j", function()
    if vim.v.count == 0 then
        return ":b#<CR>"
    end
    return "<cmd>LualineBuffersJump " .. vim.v.count .. "<CR>"
end, { expr = true })
