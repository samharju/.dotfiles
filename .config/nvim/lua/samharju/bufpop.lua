local ns = vim.api.nvim_create_namespace("bufpop")

local M = { opts = {} }

---Open popup.
---@param buffer integer bufnum to show
---@param h integer height
---@param w integer width
---@return integer
local function open_popup(buffer, h, w)
    local winid = vim.api.nvim_open_win(buffer, false, {
        focusable = false,
        relative = "editor",
        width = w,
        height = h,
        row = vim.o.lines - vim.o.cmdheight - h - 3,
        col = 0,
        style = "minimal",
        border = "rounded",
        title = "Buffers",
        title_pos = "center",
    })
    vim.wo[winid].winhl = "NormalFloat:Normal"
    return winid
end

---Populate given buffer with open buffer names.
---Returns two numbers, line count and columns on longest line.
---@param buffer integer
---@return integer
---@return integer
local function populate_buffer(buffer)
    local bufs = {}
    local hi = -1
    local current_bufnr = vim.api.nvim_get_current_buf()
    local w = 0

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
            if name == "" then name = "[No Name]" end
            w = math.max(w, #name)
            if buf == current_bufnr then hi = #bufs end
            table.insert(bufs, name)
        end
    end

    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, bufs)
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
    if hi ~= -1 then vim.api.nvim_buf_add_highlight(buffer, ns, "Keyword", hi, 0, -1) end

    return #bufs, w
end

local popup_buf = nil
local popup_win = nil

---Open popup that is closed automatically.
local function bufpopup()
    if popup_buf == nil then popup_buf = vim.api.nvim_create_buf(false, true) end
    local h, w = populate_buffer(popup_buf)
    local winid = open_popup(popup_buf, h, w)
    if popup_win ~= nil and vim.api.nvim_win_is_valid(popup_win) then vim.api.nvim_win_hide(popup_win) end
    popup_win = winid
    vim.defer_fn(function() pcall(vim.api.nvim_win_close, winid, true) end, M.opts.delay)
end

---@class bufpop.Options
---@field delay integer

local defaultopts = {
    delay = 1000,
}
---@param opts? bufpop.Options
function M.setup(opts)
    M.opts = setmetatable(opts or {}, { __index = defaultopts })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("bufpop", { clear = true }),
        callback = function(_) bufpopup() end,
    })
end

return M
