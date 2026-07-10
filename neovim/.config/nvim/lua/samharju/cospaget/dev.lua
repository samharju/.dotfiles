local M = {}

function M.log(...)
    if not vim.g.cospaget_debug then return end

    if vim.g.logbuf == nil then
        local win = vim.api.nvim_get_current_win()
        vim.g.logbuf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(vim.g.logbuf, "logi")
        vim.cmd("split")
        vim.cmd("wincmd L")
        vim.api.nvim_set_current_buf(vim.g.logbuf)
        vim.opt_local.wrap = true
        vim.api.nvim_set_current_win(win)
    end

    local args = { ... }
    for index, value in ipairs(args) do
        if type(value) == "table" then
            args[index] = vim.inspect(value)
        else
            args[index] = tostring(value)
        end
    end

    local msg = table.concat(args, " ")

    local s = debug.getinfo(2, "Sl")
    local file = s.source:match("lua/(.*.lua)$")
    local line = s.currentline

    local logline = string.format("[%s] %s:%s: %s\n", os.date(), file, line, msg)
    vim.api.nvim_buf_set_lines(vim.g.logbuf, -1, -1, false, vim.split(logline, "\n"))
end

return M
