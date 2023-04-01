--vim.cmd.colorscheme('tokyonight-moon')


require 'synthwave84'.setup({
    glow = {
        error_msg = true,
        type2 = true,
        func = true,
        keyword = true,
        operator = false,
        buffer_current_target = true,
        buffer_visible_target = true,
        buffer_inactive_target = true,
    }
})

vim.cmd.colorscheme('synthwave84')


--require('rose-pine').setup({
--    --- @usage 'auto'|'main'|'moon'|'dawn'
--    variant = 'auto',
--    --- @usage 'main'|'moon'|'dawn'
--    dark_variant = 'main',
--    bold_vert_split = false,
--    dim_nc_background = false,
--    disable_background = false,
--    --disable_float_background = true,
--    disable_italics = true,
--})

--vim.cmd.colorscheme('rose-pine')

--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })