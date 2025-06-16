local c = require("samharju.status.components")

local M = {}

function M.update(winid)
    local buf = vim.api.nvim_win_get_buf(winid)
    -- if not vim.api.nvim_get_option_value("buflisted", { buf = buf }) then return "" end

    local fname = vim.api.nvim_buf_get_name(buf)
    if not fname then return "" end

    local diag = c.diagnostics(buf)

    return c.join({
        "%f",
        diag,
        c.lint_progress(buf),
    }, " ")
end

return M
