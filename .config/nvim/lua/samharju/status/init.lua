local M = {
    _tabline = "",
    _statusline = "",
    tabline = true,
    status = true,
    winbar = false,
}

local winbars = function()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(winid).relative == "" then
            vim.wo[winid].winbar = require("samharju.status.winbar").update(winid)
        end
    end
end

local throttle = false
local timer = vim.uv.new_timer()

function M.update_now()
    if M.status then M._statusline = require("samharju.status.statusline").update() end
    if M.tabline then M._tabline = require("samharju.status.tabline").update() end
    if M.winbar then winbars() end
end

function M.update()
    if throttle then
        return
    end
    vim.defer_fn(function() throttle = false end, 250)
    throttle = true
    M.update_now()
end

function M.setup()
    local group = vim.api.nvim_create_augroup("samharju_statusline", { clear = true })

    if M.tabline then
        vim.opt.showtabline = 2
        _G.MyTabline = function() return M._tabline end
        vim.opt.tabline = "%{%v:lua.MyTabline()%}"
    end

    if M.status then
        _G.MyStatus = function() return M._statusline end
        vim.opt.statusline = "%{%v:lua.MyStatus()%}"
    end

    require("samharju.status.hl").setup(group)

    vim.api.nvim_create_autocmd({ "BufWritePost", "VimEnter", "BufEnter" }, {
        group = group,
        callback = M.update_now,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "FugitiveChanged",
        group = group,
        callback = require("samharju.status.git").check_branch,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = group,
        callback = M.update,
    })

    vim.uv.timer_start(timer, 0, 200, vim.schedule_wrap(M.update))
end

M.setup()
