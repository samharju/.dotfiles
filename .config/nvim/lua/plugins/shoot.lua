return {
    dir = '~/plugins/samharju/shoot.nvim',
    keys = {
        { '<leader>o', function() require('shoot').select_target() end }
    }
}
