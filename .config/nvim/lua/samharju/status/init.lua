local status = require("samharju.status.statusline")
local tab = require("samharju.status.tabline")

local tabline = ""
local winbar = "%f %h%r%m"
local statusline = ""

_G.MyStatus = function() return statusline end
_G.Tabline = function() return tabline end

vim.opt.showtabline = 2
vim.opt.tabline = "%{%v:lua.Tabline()%}"
vim.opt.laststatus = 3
vim.opt.statusline = "%{%v:lua.MyStatus()%}"
vim.opt.winbar = winbar

local group = vim.api.nvim_create_augroup("samharju_statusline", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = group,
    callback = function()
        local stl_default = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
        local diffAdd = vim.api.nvim_get_hl(0, { name = "DiffAdded", link = false })
        local diffChange = vim.api.nvim_get_hl(0, { name = "DiffChanged", link = false })
        local diffDelete = vim.api.nvim_get_hl(0, { name = "DiffRemoved", link = false })

        vim.api.nvim_set_hl(0, "User1", { fg = diffAdd.fg, bg = stl_default.bg, reverse = stl_default.reverse })
        vim.api.nvim_set_hl(0, "User2", { fg = diffChange.fg, bg = stl_default.bg, reverse = stl_default.reverse })
        vim.api.nvim_set_hl(0, "User3", { fg = diffDelete.fg, bg = stl_default.bg, reverse = stl_default.reverse })
    end,
})

local throttle = false
local wait = vim.loop.new_timer()

local function update()
    throttle = true

    tabline = tab.update()
    statusline = status.update()

    if wait ~= nil then vim.loop.timer_start(wait, 1000, 0, function() throttle = false end) end
end

vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function()
        if not throttle then update() end
    end,
})

vim.api.nvim_create_autocmd(
    { "VimEnter", "BufEnter", "BufWritePost", "CmdlineEnter", "CmdlineLeave", "InsertLeave", "BufLeave" },
    {
        group = group,
        callback = update,
    }
)
