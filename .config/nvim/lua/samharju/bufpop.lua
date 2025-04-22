local M = { opts = { auto = false } }

---@class bufpop.Buffer
---@field name string
---@field buffer integer
---@field label string

local ns = vim.api.nvim_create_namespace("bufpop")

local make_config = function(h, w, style, relative)
    local common = {
        focusable = false,
        style = "minimal",
        title = "Buffers",
        title_pos = "left",
    }

    local win_configs = {
        float = {
            relative = "editor",
            width = w + vim.o.sidescrolloff,
            height = h,
            row = vim.o.lines - vim.o.cmdheight - h - 3,
            col = 0,
            border = "rounded",
        },
        center = {
            relative = "win",
            width = w + vim.o.sidescrolloff,
            height = h,
            row = vim.api.nvim_win_get_height(0) / 2 - h / 2,
            col = vim.api.nvim_win_get_width(0) / 2 - w / 2,
            border = "single",
        },
        cursor = {
            relative = "cursor",
            width = w + vim.o.sidescrolloff,
            height = h,
            row = 1,
            col = 1,
            border = "single",
        },
        bottom = {
            relative = "editor",
            width = vim.o.columns,
            height = h + 1,
            row = vim.api.nvim_win_get_height(0) - h - 2,
            col = 0,
            style = "minimal",
            border = { "─", "─", "─", "", "", "", "", " " },
        },
        top = {
            relative = "win",
            width = vim.api.nvim_win_get_width(0),
            height = h,
            row = 0,
            col = 0,
            style = "minimal",
            border = { "", "", "", "", "─", "─", "─", "" },
        },
    }

    return vim.tbl_extend("force", common, win_configs[style])
end

---Open popup.
---@param buffer integer bufnum to show
---@param h integer height
---@param w integer width
---@param style string layout
---@param enter boolean
---@return integer
local function open_popup(buffer, h, w, style, enter)
    local cfg = make_config(h, w, style)
    local winid = vim.api.nvim_open_win(buffer, enter, cfg)
    vim.wo[winid].winhl = "NormalFloat:Normal"
    return winid
end

---@type bufpop.Buffer[]
local buffers = {}

---Populate given buffer with open buffer names.
---Returns two numbers, line count and columns on longest line.
---@param buffer integer
---@return integer
---@return integer
local function populate_buffer(buffer)
    local hi = -1
    local current_bufnr = vim.api.nvim_get_current_buf()

    local w = 0

    buffers = {}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
            if vim.api.nvim_buf_get_name(buf) ~= "" then
                local c = #buffers + 1
                ---@type bufpop.Buffer
                local b = {
                    name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."),
                    buffer = buf,
                    label = M.opts.labels:sub(c, c),
                }
                w = math.max(w, #b.name)
                table.insert(buffers, b)
                if buf == current_bufnr then hi = #buffers end
            end
        end
    end

    local lines = {}
    for _, v in ipairs(buffers) do
        table.insert(lines, v.name)
    end

    vim.api.nvim_set_option_value("modifiable", true, { buf = buffer })
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

    if hi ~= -1 then vim.api.nvim_buf_add_highlight(buffer, ns, "Keyword", hi - 1, 0, -1) end
    for i, b in ipairs(buffers) do
        vim.api.nvim_buf_set_extmark(buffer, ns, i - 1, 0, { sign_hl_group = "Type", sign_text = b.label })
    end

    return #buffers, w
end

local popup_buf = nil
local popup_win = nil

---@class bufpop.Opts
---@field style string
---@field auto boolean
---@field enter boolean

---Open popup that is closed automatically.
---@param opts bufpop.Opts
local function bufpopup(opts)
    if popup_buf == nil then
        popup_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(popup_buf, "bufpop.nvim")
    end
    local cbuf = vim.api.nvim_get_current_buf()
    if cbuf == popup_buf then return end

    local h, w = populate_buffer(popup_buf)
    if h == 0 then return end

    local winid = open_popup(popup_buf, h, w, opts.style, opts.enter)

    if popup_win ~= nil and vim.api.nvim_win_is_valid(popup_win) then vim.api.nvim_win_hide(popup_win) end

    popup_win = winid

    if opts.auto then
        vim.defer_fn(function() pcall(vim.api.nvim_win_close, winid, true) end, M.opts.delay)
        return
    end

    local files = vim.api.nvim_buf_get_lines(popup_buf, 0, -1, false)
    for i = 1, #files, 1 do
        local l = M.opts.labels:sub(i, i)
        if l ~= "" then
            vim.keymap.set("n", l, function()
                vim.cmd.wincmd("p")
                vim.api.nvim_set_current_buf(buffers[i].buffer)
                vim.api.nvim_win_close(popup_win, true)
            end, { buffer = popup_buf })
        end
    end

    vim.keymap.set("n", "<CR>", function()
        local pos = vim.fn.getpos(".")
        vim.cmd.wincmd("p")
        vim.api.nvim_set_current_buf(buffers[pos[2]].buffer)
        vim.api.nvim_win_close(popup_win, true)
    end, { buffer = popup_buf })

    vim.keymap.set("n", "<C-x>", function()
        local pos = vim.fn.getpos(".")
        vim.cmd.wincmd("p")
        vim.api.nvim_buf_delete(buffers[pos[2]].buffer, {})
        bufpopup(opts)
    end, { buffer = popup_buf })

    vim.keymap.set("n", "<C-v>", function()
        local _, i, _, _ = vim.fn.getpos(".")
        vim.cmd.wincmd("p")
        vim.cmd.vsplit()
        vim.cmd.e(buffers[i].name)
        vim.api.nvim_win_close(popup_win, true)
    end, { buffer = popup_buf })

    vim.keymap.set("n", "q", function() vim.cmd.wincmd("q") end, { buffer = popup_buf })
end

---@class bufpop.Options
---@field delay? integer
---@field auto? boolean

local defaultopts = {
    delay = 1000,
}
---@param opts? bufpop.Options
function M.setup(opts)
    M.opts = setmetatable(opts or {}, { __index = defaultopts })

    vim.api.nvim_create_user_command(
        "BufPop",
        function(args) bufpopup({ style = args.args, auto = false, enter = true }) end,
        { nargs = 1 }
    )

    if M.opts.auto then
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("bufpop", { clear = true }),
            callback = function(ev)
                if not vim.api.nvim_get_option_value("buflisted", { buf = ev.buffer }) then return end
                bufpopup({ style = "bottom", auto = true, enter = false })
            end,
            -1,
        })
    end
end

M.setup({ auto = false, labels = "asdfhjkl" })
vim.keymap.set("n", "<leader>m", function() bufpopup({ style = "cursor", auto = false, enter = true }) end)

return M
