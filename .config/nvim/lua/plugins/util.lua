return {
    {
        "folke/flash.nvim",
        opts = {
            modes = { search = { enabled = false } },
        },
        keys = {
            {
                "s",
                function() require("flash").jump() end,
                desc = "flash search",
            },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "UndotreeToggle" },
        },
    },
    {
        "terrortylor/nvim-comment",
        event = "VeryLazy",
        config = function() require("nvim_comment").setup() end,
    },
}
