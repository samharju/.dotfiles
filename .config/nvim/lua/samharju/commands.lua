local cmd = vim.api.nvim_create_user_command

-- cmon not an editor command: W
cmd('W', 'w', {})


-- clear registers
cmd('ClearRegs', function(_)
    local regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    for r in regs:gmatch('.') do
        local val = vim.fn.getreg(r)
        if val ~= '' then
            vim.fn.setreg(r, '')
        end
    end
end, { desc = 'Clear registers abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' })
