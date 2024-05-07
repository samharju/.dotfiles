vim.api.nvim_create_user_command("ColorMyPencils", function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end, {})

return {
    {
        "eldritch-theme/eldritch.nvim",
        opts = {},
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function() require("rose-pine").setup({ styles = { italic = false } }) end,
    },
    {
        "samharju/synthweave.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000,
        config = function() vim.cmd.colorscheme("synthweave") end,
    },
}
