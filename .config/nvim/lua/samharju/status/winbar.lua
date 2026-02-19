local c = require("samharju.status.components")

local M = {}

function M.update(winid)
    local buf = vim.api.nvim_win_get_buf(winid)
    if vim.bo[buf].filetype == "dap-view" then return end
    if not vim.bo[buf].buflisted then return " " end

    local fname = vim.api.nvim_buf_get_name(buf)
    if not fname then return " " end

    return c.join({
        vim.fn.fnamemodify(fname, ":."),
        c.diagnostics(buf),
        c.lint_progress(buf),
    }, " ")
end

return M
