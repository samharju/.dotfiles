return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        keys = {
            {
                "<leader>gs",
                function()
                    vim.cmd("vert Git")
                    vim.cmd("vert res 88")
                end,
                desc = "git fugitive",
            },
            { "<leader>gv", ":Gvdiffsplit ", desc = "git diff split" },
            { "<leader>gb", ":Git blame<CR>", desc = "git blame" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            current_line_blame_opts = {
                delay = 0,
                virt_text_pos = "eol",
            },
        },
        keys = {
            {
                "<leader>hs",
                function() require("gitsigns").stage_hunk() end,
                { desc = "git stage hunk" },
            },
            {
                "<leader>hu",
                function() require("gitsigns").reset_hunk() end,
                { desc = "git undo hunk" },
            },
            {
                "<leader>hp",
                function() require("gitsigns").preview_hunk() end,
                { desc = "git preview hunk" },
            },
            {
                "<leader>hb",
                function() require("gitsigns").blame_line() end,
                { desc = "git blame line" },
            },
            {
                "<leader>hh",
                function() require("gitsigns").toggle_current_line_blame() end,
                { desc = "git toggle current line blame" },
            },
            {
                "<leader>gg",
                function() require("gitsigns").toggle_linehl() end,
                { desc = "git toggle linehl" },
            },
            {
                "]c",
                function() require("gitsigns").next_hunk() end,
                { desc = "git next hunk" },
            },
            {
                "[c",
                function() require("gitsigns").prev_hunk() end,
                { desc = "git prev hunk" },
            },
            {
                "<leader>hq",
                function() require("gitsigns").setqflist() end,
                { desc = "git hunk qf" },
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        cmd = "DiffviewOpen",
    },
}
