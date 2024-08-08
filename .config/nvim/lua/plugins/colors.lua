return {
    {
        "eldritch-theme/eldritch.nvim",
        opts = {},
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
    },
    {
        "samharju/synthweave.nvim",
        dev = true,
    },
    {
        "samharju/serene.nvim",
        config = function() vim.cmd([[ colorscheme serene ]]) end,
    },
}
