return {
    "projekt0n/github-nvim-theme",
    {
        "samharju/synthweave.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000,
        config = function() vim.cmd.colorscheme("synthweave") end,
    },
}
