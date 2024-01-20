return {
    'theprimeagen/harpoon',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('harpoon').setup({
            enter_on_sendcmd = true,
            tabline = true,
            tabline_prefix = '   ',
            tabline_suffix = '',
        })


        local function checkcmds()
            if require('harpoon.term').get_length() == 0 then
                print("no command to run...")
                return false
            end
            return true
        end

        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        vim.keymap.set('n', '<leader>a', mark.add_file)
        vim.keymap.set('n', '<leader>e', ui.toggle_quick_menu)

        vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'harpoonfile 1' })
        vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'harpoonfile 2' })
        vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'harpoonfile 3' })
        vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'harpoonfile 4' })
        vim.keymap.set('n', '<leader>n', ui.nav_next, { desc = 'harpoon next' })

        vim.api.nvim_set_hl(0, 'HarpoonActive', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, 'HarpoonNumberActive', { link = 'Special' })
        vim.api.nvim_set_hl(0, 'HarpoonInactive', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'HarpoonNumberInactive', { link = 'Comment' })

        vim.keymap.set('n', '<leader><BS>', require('harpoon.cmd-ui').toggle_quick_menu)
        vim.keymap.set('n', '\\\\', function()
            if not checkcmds() then
                return
            end
            require('harpoon.term').sendCommand(1, 'clear')
            require('harpoon.term').sendCommand(1, 1)
        end, { desc = 'harpoon run first command' })

        vim.keymap.set('n', '\\2', function()
            if not checkcmds() then
                return
            end
            require('harpoon.term').sendCommand(1, 'clear')
            require('harpoon.term').sendCommand(1, 2)
        end, { desc = 'harpoon run second command' })

        vim.keymap.set('n', '\\3', function()
            if not checkcmds() then
                return
            end
            require('harpoon.term').sendCommand(1, 'clear')
            require('harpoon.term').sendCommand(1, 3)
        end, { desc = 'harpoon run third command' })

        local grp = vim.api.nvim_create_augroup('samharju', { clear = true })

        local function detach()
            vim.api.nvim_clear_autocmds({ group = grp })
            print('samharju cleared')
        end

        local function attach()
            if not checkcmds() then
                return
            end
            vim.api.nvim_create_autocmd('BufWritePost', {
                group = vim.api.nvim_create_augroup('samharju', { clear = true }),
                callback = function()
                    if not checkcmds() then
                        return
                    end
                    require('harpoon.term').sendCommand(1, 'clear')
                    require('harpoon.term').sendCommand(1, 1)
                end
            })
            vim.api.nvim_exec_autocmds('BufWritePost', { group = grp })
        end

        vim.keymap.set('n', '<leader>l', attach, { desc = 'harpoon run first command on save' })
        vim.keymap.set('n', '<leader>o', detach, { desc = 'harpoon clear command on save' })

        require("telescope").load_extension('harpoon')
    end
}
