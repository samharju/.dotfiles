return {
    {
        "folke/flash.nvim",
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
        keys = { { "<leader>u", vim.cmd.UndotreeToggle, desc = "UndotreeToggle" } },
    },
    {
        "terrortylor/nvim-comment",
        event = "VeryLazy",
        config = function() require("nvim_comment").setup() end,
    },
    {
        "eandrju/cellular-automaton.nvim",
        keys = {
            { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>" },
            { "<leader>fts", "<cmd>CellularAutomaton game_of_life<CR>" },
        },
    },
}
