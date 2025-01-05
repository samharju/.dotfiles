local tabline = ""
local statusline = ""

_G.MyStatus = function() return statusline end
_G.Tabline = function() return tabline end

local function update()
    statusline = require("samharju.status.statusline").update()
    -- tabline = require("samharju.status.tabline").update()
end

vim.opt.showtabline = 1
-- vim.opt.tabline = "%{%v:lua.Tabline()%}"
vim.opt.laststatus = 3
vim.opt.statusline = "%{%v:lua.MyStatus()%}"
vim.opt.winbar = "%t %h%r%m"

local group = vim.api.nvim_create_augroup("samharju_statusline", { clear = true })
require("samharju.status.hl").setup(group)

--- statusline updates with some sane throttling
local throttle = false

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
