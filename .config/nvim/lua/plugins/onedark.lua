return {
    'navarasu/onedark.nvim',
    opts = {
        style = 'deep',
        transparent = true,
        toggle_style_key = '<leader>st',
        toggle_style_list = { 'dark', 'darker', 'cool', 'deep' },
    },
    init = function()
        require('onedark').load()
    end
}
