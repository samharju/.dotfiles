local cmd = vim.api.nvim_create_user_command

-- vim.notify({msg}, {level}, {opts})                              *vim.notify()*
--     Displays a notification to the user.
--
--     This function can be overridden by plugins to display notifications using
--     a custom provider (such as the system notification provider). By default,
--     writes to |:messages|.
--
--     Parameters: ~
--       • {msg}    (`string`) Content of the notification to show to the user.
--       • {level}  (`integer?`) One of the values from |vim.log.levels|.
--       • {opts}   (`table?`) Optional parameters. Unused by default.

local notify_buf = vim.api.nvim_create_buf(false, true)
vim.keymap.set("n", "q", ":q<CR>", { buffer = notify_buf })
local notif_win = -1
local notif_timer = vim.uv.new_timer()

cmd("Notifications", function(args)
    vim.cmd("vert split")
    vim.api.nvim_set_current_buf(notify_buf)
end, {})

local function notify_win_timer()
    vim.uv.timer_start(
        notif_timer,
        3000,
        0,
        vim.schedule_wrap(function()
            if vim.api.nvim_win_is_valid(notif_win) then vim.api.nvim_win_close(notif_win, true) end
        end)
    )
end

local function create_win()
    if not vim.api.nvim_win_is_valid(notif_win) then
        local w = math.max(math.floor(vim.o.columns / 4), 20)
        local offset = 2
        notif_win = vim.api.nvim_open_win(notify_buf, false, {
            relative = "editor",
            style = "minimal",
            border = "rounded",
            row = offset,
            col = vim.o.columns - 1 - w,
            width = w,
            height = vim.o.lines - 1 - 3 - offset,
        })
        vim.wo[notif_win].winhighlight = "NormalFloat:Comment,FloatBorder:Comment"
        vim.wo[notif_win].wrap = false
        notify_win_timer()
    end
end

local function create_small_win()
    if not vim.api.nvim_win_is_valid(notif_win) then
        notif_win = vim.api.nvim_open_win(notify_buf, false, {
            relative = "editor",
            style = "minimal",
            border = "rounded",
            row = vim.o.lines - 5,
            col = math.floor(vim.o.columns / 3),
            width = math.floor(vim.o.columns / 3) - 2,
            height = 1,
        })
        vim.wo[notif_win].winhighlight = "NormalFloat:Comment,FloatBorder:Comment"
        vim.wo[notif_win].wrap = false
        notify_win_timer()
    end
end

local function notif(msg, level, opts)
    if msg == nil then return end

    if type(msg) ~= "string" then msg = vim.inspect(msg) end

    if level ~= nil and type(level) ~= "number" and type(level) ~= "string" then
        error("level: expected number | string, got " .. type(level))
    end
    if opts ~= nil and type(opts) ~= "table" then error("opts: expected table, got " .. type(opts)) end

    if opts and opts.small then
        create_small_win()
    else
        create_win()
    end

    vim.api.nvim_buf_set_lines(notify_buf, -1, -1, false, vim.split(msg, "\n"))
    local r = #vim.api.nvim_buf_get_lines(notify_buf, 0, -1, false)
    vim.api.nvim_win_set_cursor(notif_win, { r, 0 })
    vim.uv.timer_stop(notif_timer)
    notify_win_timer()
end

local M = {}

M.big = notif
M.small = function(msg, level, opts)
    opts = opts or {}
    opts.small = true
    notif(msg, level, opts)
end

return M
