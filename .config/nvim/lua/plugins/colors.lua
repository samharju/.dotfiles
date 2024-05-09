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
