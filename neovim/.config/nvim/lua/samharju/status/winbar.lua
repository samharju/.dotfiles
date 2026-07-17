local c = require("samharju.status.components")
local git = require("samharju.status.git")

local M = {}

function M.update(winid)
    local buf = vim.api.nvim_win_get_buf(winid)
    if vim.bo[buf].filetype == "dap-view" then return end
    if not vim.bo[buf].buflisted then return " " end

    local fname = vim.api.nvim_buf_get_name(buf)
    if not fname then return " " end

    local diff = vim.b[buf].gitsigns_status_dict
    if diff then diff = git.format_diff_str(diff) end

    return c.join({
        vim.fn.fnamemodify(fname, ":."),
        diff,
        c.diagnostics(buf),
        c.lint_progress(buf),
    }, " ")
end

return M
