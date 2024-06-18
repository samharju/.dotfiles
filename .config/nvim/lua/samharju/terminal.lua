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

local function smart_terminal()
    local buf = nil
    for _, chan in ipairs(vim.api.nvim_list_chans()) do
        if chan.mode == "terminal" then
            buf = chan.buffer
            break
        end
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_set_current_win(win)
            vim.cmd.startinsert()
            return
        end
    end

    vim.cmd.new()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 12)
    if buf == nil then
        vim.cmd("terminal")
        vim.api.nvim_buf_set_name(0, "term")
    else
        vim.api.nvim_set_current_buf(buf)
    end
    vim.wo.winfixbuf = true
    vim.wo.winfixheight = true
    vim.cmd.startinsert()
end

-- esc to normal mode in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- open terminal without spamming new windows
vim.keymap.set("n", "<leader>t", smart_terminal)
