local M = {
    _tabline = "",
    _statusline = "",
    tabline = true,
    status = true,
    winbar = true,
    update_interval = 100,
    throttle_duration = 250,
}

local winbars = function()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(winid).relative == "" then
            local winb = require("samharju.status.winbar").update(winid)
            if winb ~= nil then vim.wo[winid].winbar = winb end
        end
    end
end

local throttle = false
local timer = vim.uv.new_timer()

function M.update_now()
    if M.status then M._statusline = require("samharju.status.statusline").update() end
    if M.tabline then M._tabline = require("samharju.status.tabline").update() end
    if M.winbar then winbars() end
    vim.cmd.redrawstatus()
end

function M.update()
    if throttle then return end
    vim.defer_fn(function() throttle = false end, M.throttle_duration)
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

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        group = group,
        callback = M.update_now,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "FugitiveChanged",
        group = group,
        callback = function() require("samharju.status.git").update() end,
    })

    -- vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    --     group = group,
    --     callback = M.update_now,
    -- })

    vim.uv.timer_start(timer, 0, M.update_interval, vim.schedule_wrap(M.update))
end

M.setup()
