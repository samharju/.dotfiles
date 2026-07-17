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

cmd("Notifications", function(_)
    vim.cmd("vert split")
    vim.api.nvim_set_current_buf(notify_buf)
end, {})

local function notify_win_timer()
    assert(notif_timer)
    notif_timer:start(
        3000,
        0,
        vim.schedule_wrap(function()
            if vim.api.nvim_win_is_valid(notif_win) then vim.api.nvim_win_close(notif_win, true) end
        end)
    )
end

local function create_win(opts)
    local winopts = {
        relative = "editor",
        style = "minimal",
        border = "rounded",
        row = 2,
        col = math.floor(vim.o.columns * 2 / 3),
        width = math.floor(vim.o.columns / 3) - 2,
        height = 1,
    }
    local o = vim.tbl_extend("force", winopts, opts or {})

    if not vim.api.nvim_win_is_valid(notif_win) then
        notif_win = vim.api.nvim_open_win(notify_buf, false, o)
        vim.wo[notif_win].winhighlight = "NormalFloat:Comment,FloatBorder:Comment"
        vim.wo[notif_win].wrap = false
        notify_win_timer()
    end
end

local function notif(msg, level, opts)
    opts = opts or {}
    if msg == nil then return end

    if type(msg) ~= "string" then msg = vim.inspect(msg) end

    if level ~= nil and type(level) ~= "number" and type(level) ~= "string" then
        error("level: expected number | string, got " .. type(level))
    end
    if opts ~= nil and type(opts) ~= "table" then error("opts: expected table, got " .. type(opts)) end

    local lines = {}
    for _, line in ipairs(vim.split(msg, "\n")) do
        if line ~= "" then table.insert(lines, line) end
    end
    vim.api.nvim_buf_set_lines(notify_buf, -1, -1, false, lines)

    if opts.center then
        create_win({
            row = vim.o.lines - 8,
            col = math.floor(vim.o.columns / 3),
            width = math.floor(vim.o.columns / 3) - 2,
            height = 4,
        })
    else
        create_win()
    end

    local r = #vim.api.nvim_buf_get_lines(notify_buf, 0, -1, false)
    if opts.grow then
        local h = vim.api.nvim_win_get_height(notif_win)
        if h < r + 2 then vim.api.nvim_win_set_height(notif_win, math.min(r, vim.o.lines)) end
    end
    vim.api.nvim_win_set_cursor(notif_win, { r, 0 })
    assert(notif_timer)
    notif_timer:stop()
    notify_win_timer()
end

local M = {}

M.topright = function(msg, level, opts)
    opts = opts or {}
    opts.grow = true
    notif(msg, level, opts)
end
M.center = function(msg, level, opts)
    opts = opts or {}
    opts.center = true
    notif(msg, level, opts)
end

return M
