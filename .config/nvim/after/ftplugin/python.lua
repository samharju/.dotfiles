vim.keymap.set("n", "<leader>bm", function() require("dap-python").test_method() end)

vim.opt_local.errorformat = {
    ' %#File "%f"\\, line %l\\, %m',
    ' %#File "%f"\\, line %l',
    "%f:%l:%c: %m",
    "%f:%l: %m",
    "%f:%l:",
    "%+GERROR: %m",
    "%+GFAIL: %m",
    "E %#%m",
    "%+G%.%#%trror%m",
    "%+GFAILED %m",
    "%+GTraceback%m",
    "%-G%.%#",
}

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = vim.api.nvim_create_augroup("custom_ft_python", { clear = true }),
    callback = function()
        local qf = vim.fn.getqflist()

        for _, value in ipairs(qf) do
            if value.bufnr ~= 0 then
                local fname = vim.api.nvim_buf_get_name(value.bufnr)
                if string.match(fname, "^/api") then
                    value.bufnr = nil
                    value.filename = fname.sub(fname, 2)
                elseif string.match(fname, "^/opt/venv") then
                    value.bufnr = nil
                    value.filename = fname.sub(fname, 6)
                end
            end
        end
        vim.fn.setqflist(qf)
    end,
})

vim.api.nvim_create_user_command("RefreshEfm", function()
    vim.cmd([[ so ~/.config/nvim/after/ftplugin/python.lua ]])
    vim.cmd.cgetfile("/tmp/yeeterr")
end, {})

vim.schedule(function()
    local active, exists, _ = require("samharju.venv").check_venv()

    if exists and not active then
        local buf = vim.api.nvim_create_buf(false, true)
        local msg = "          venv not activated"
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            "",
            msg,
            "",
        })
        local w = 38
        local h = 7
        local winid = vim.api.nvim_open_win(buf, false, {
            relative = "win",
            width = w,
            height = 3,
            row = vim.o.lines - h - 2,
            col = vim.o.columns - w - 5,
            style = "minimal",
            border = "rounded",
        })
        vim.wo[winid].winhl = "FloatBorder:DiagnosticWarn,Normal:DiagnosticWarn"

        vim.defer_fn(function() vim.api.nvim_win_close(winid, true) end, 4000)
    end
end)
