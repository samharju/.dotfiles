return {
    dir = '~/plugins/samharju/yeet.nvim',
    opts = {},
    keys = {
        { '<leader>ot', function() require('yeet').select_target() end },
        { '<leader>oc', function() require('yeet').set_cmd() end },
        { '<leader>oo', function() require('yeet').execute() end }
    },
    cmd = 'Yeet'
}
