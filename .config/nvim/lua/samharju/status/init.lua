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

local function update()
    statusline = status.update()
    tabline = tab.update()
end

vim.api.nvim_create_autocmd({ "BufWritePost", "VimEnter", "BufEnter", "CmdlineLeave", "DiagnosticChanged" }, {
    group = group,
    callback = update,
})

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    group = group,
    callback = function()
        if throttle then return end
        throttle = true
        update()
        vim.defer_fn(function() throttle = false end, 1000)
    end,
})
