return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        keys = {
            {
                "<leader>gs",
                function()
                    vim.cmd("vert Git")
                    vim.cmd("wincmd H")
                    vim.cmd("vert res 69")
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
            signs = {
                add = { text = "▌" },
                change = { text = "▌" },
                delete = { text = "🬭" },
                topdelete = { text = "🬂" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
        },
        keys = {
            {
                "<leader>hs",
                function() require("gitsigns").stage_hunk() end,
                { desc = "git hunk stage" },
            },
            {
                "<leader>hu",
                function() require("gitsigns").reset_hunk() end,
                { desc = "git hunk undo" },
            },
            {
                "<leader>hp",
                function() require("gitsigns").preview_hunk() end,
                { desc = "git hunk preview" },
            },
            {
                "<leader>hb",
                function() require("gitsigns").blame_line({ full = true }) end,
                { desc = "git hunk blame" },
            },
            {
                "<leader>hh",
                function() require("gitsigns").toggle_current_line_blame() end,
                { desc = "git toggle current line blame" },
            },
            {
                "<leader>hg",
                function() require("gitsigns").toggle_linehl() end,
                { desc = "git hunk gutter" },
            },
            {
                "]c",
                function() require("gitsigns").next_hunk() end,
                { desc = "git hunk next" },
            },
            {
                "[c",
                function() require("gitsigns").prev_hunk() end,
                { desc = "git hunk prev" },
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        cmd = "DiffviewOpen",
    },
}
