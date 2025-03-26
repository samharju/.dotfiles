local cache_window_opts = function()
    local width = math.max(math.ceil(0.8 * vim.o.columns), 120)
    local height = math.max(math.ceil(0.8 * vim.o.lines), 20)

    return {
        relative = "editor",
        row = (vim.o.lines - height) * 0.5,
        col = (vim.o.columns - width) * 0.5,
        width = width,
        height = height,
        border = "single",
    }
end

vim.api.nvim_open_win(0, true, cache_window_opts())
