M = {}

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("sami_terminal", { clear = true }),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.cursorline = false
        vim.bo.filetype = "terminal"
    end,
})

local state = {
    buf = -1,
    win = -1,
    scale = 0.8,
}

local floor = math.floor

local wo = function(opts)
    local width = floor(state.scale * vim.o.columns)
    local height = floor(state.scale * vim.o.lines)
    local row = floor((vim.o.lines - height) * 0.4)
    local col = floor((vim.o.columns - width) * 0.5)

    local out = {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        border = "rounded",
    }
    return vim.tbl_extend("force", out, opts or {})
end

local function adjust_scale(dir)
    if dir == 1 then
        state.scale = state.scale + 0.1
    elseif dir == -1 then
        state.scale = state.scale - 0.1
    end
    vim.notify(tostring(state.scale))

    local opts = {}
    if state.scale >= 1 then
        state.scale = 1
        opts.border = "solid"
    elseif state.scale < 0.4 then
        state.scale = 0.4
    end

    if vim.api.nvim_win_is_valid(state.win) then vim.api.nvim_win_set_config(state.win, wo(opts)) end
end

M.float_terminal = function()
    if not vim.api.nvim_win_is_valid(state.win) then
        state.win = vim.api.nvim_open_win(0, true, wo())

        if not vim.api.nvim_buf_is_valid(state.buf) or vim.bo[state.buf].buftype ~= "terminal" then
            local b = nil
            for _, chan in ipairs(vim.api.nvim_list_chans()) do
                if chan.mode == "terminal" then
                    b = chan.buffer
                    break
                end
            end

            if b then
                state.buf = b
            else
                vim.cmd.term()
                state.buf = vim.api.nvim_get_current_buf()
                vim.keymap.set("n", "<leader>=", function() adjust_scale(1) end, { buffer = state.buf })
                vim.keymap.set("n", "<leader>-", function() adjust_scale(-1) end, { buffer = state.buf })
            end
        end

        vim.api.nvim_win_set_buf(state.win, state.buf)
        vim.cmd.startinsert()
    else
        vim.api.nvim_win_hide(state.win)
    end
end

-- esc to normal mode in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- open terminal without spamming new windows
vim.keymap.set("n", "<leader><tab>", M.float_terminal)

return M
