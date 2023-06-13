local autoid = 0

local attach = function(buf, outputbuf, command)
    local group = vim.api.nvim_create_augroup("stetson", { clear = true })
    autoid = vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        buffer = buf,
        callback = function()
            vim.api.nvim_buf_set_lines(outputbuf, 0, -1, false, {})
            local append = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(outputbuf, -1, -1, false, data)
                end
            end
            vim.fn.jobstart(command, {
                stdout_buffered = true,
                stderr_buffered = true,
                on_stdout = append,
                on_stderr = append
            })
        end
    })
end


vim.api.nvim_create_user_command("OnWrite", function(opts)
    attach(vim.api.nvim_get_current_buf(), tonumber(opts.fargs[1]), vim.fn.input("cmd: "))
end, { nargs = 1 })

vim.api.nvim_create_user_command("OnWriteOff", function()
    vim.api.nvim_del_autocmd(autoid)
end, {})


local pasd = vim.api.nvim_create_namespace("sami")

vim.api.nvim_create_user_command("Asda", function(opts)
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_extmark(
        vim.api.nvim_get_current_buf(),
        pasd,
        r - 1,
        0,
        {
            virt_text = { { opts.fargs[1], "WarningMsg" } }
        }
    )
end, { nargs = 1 })



vim.api.nvim_create_user_command("AsdaOff", function()
    vim.api.nvim_buf_clear_namespace(0, pasd, 0, -1)
end, {})
