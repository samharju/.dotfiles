local status = require("samharju.status.statusline")
local tab = require("samharju.status.tabline")

local tabline = ""
local winbar = "%f %h%r%m"
local statusline = ""

_G.MyStatus = function() return statusline end
_G.Tabline = function() return tabline end

local group = vim.api.nvim_create_augroup("samharju_statusline", { clear = true })
require("samharju.status.hl").setup(group)

vim.opt.showtabline = 2
vim.opt.tabline = "%{%v:lua.Tabline()%}"
vim.opt.laststatus = 3
vim.opt.statusline = "%{%v:lua.MyStatus()%}"
vim.opt.winbar = winbar

--- statusline updates with some sane throttling
local throttle = false

vim.api.nvim_create_autocmd({ "BufWritePost", "VimEnter", "BufEnter", "CmdlineLeave" }, {
    group = group,
    callback = function()
        if throttle then return end
        throttle = true
        statusline = status.update()
        vim.defer_fn(function() throttle = false end, 500)
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = group,
    callback = function() tabline = tab.update() end,
})
