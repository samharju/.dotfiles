require('lualine').setup {
    options = {
        globalstatus = true,
    },
    tabline = {
    },
    winbar = {
        lualine_a = {},
        lualine_b = { { 'filename', path = 1 } },
        lualine_c = { 'diagnostics' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = { { 'filename', path = 1 } },
        lualine_c = { 'diagnostics' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { { 'filename', path = 1 }, 'diff', 'diagnostics' },
        lualine_y = { { 'buffers', mode = 2 } },
        lualine_x = { 'progress', 'filetype' },
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
