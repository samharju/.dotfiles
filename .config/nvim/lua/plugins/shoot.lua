return {
    dir = '~/plugins/samharju/shoot.nvim',
    keys = {
        { '<leader>ot', function() require('shoot').select_target() end },
        { '<leader>oc', function() require('shoot').set_cmd() end },
        { '<leader>oo', function() require('shoot').execute_current() end }
    }
}
