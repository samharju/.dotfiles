return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        keys = {
            {
                "<leader>gs",
                function()
                    if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "fugitive" then return end
                    vim.cmd("vert Git")
                    vim.cmd("wincmd H")
                    vim.cmd("vert res 69")
                end,
                desc = "git fugitive",
            },
            {
                "<leader>gg",
                function()
                    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
                    for _, t in ipairs(vim.api.nvim_list_tabpages()) do
                        if vim.t[t].git_page == 1 then
                            vim.api.nvim_set_current_tabpage(t)
                            vim.cmd("G")
                            vim.cmd("wincmd o")
                            vim.fn.search(fname)
                            vim.fn.feedkeys(">zz")
                            return
                        end
                    end
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.bo[buf].filetype == "fugitive" then
                            for _, winid in ipairs(vim.api.nvim_list_wins()) do
                                if vim.api.nvim_win_get_buf(winid) == buf then
                                    vim.api.nvim_set_current_win(winid)
                                    vim.cmd("wincmd o")
                                    return
                                end
                            end
                        end
                    end
                    vim.cmd("tabnew +G")
                    vim.t.git_page = 1
                    vim.cmd("wincmd o")
                    vim.fn.search(fname)
                    vim.fn.feedkeys(">zz")
                end,
                desc = "git fugitive",
            },
            { "<leader>gv", ":Gvdiffsplit HEAD<CR>", desc = "git diff split" },
            { "<leader>gb", ":Git blame<CR>", desc = "git blame" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            current_line_blame_opts = {
                delay = 1000,
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
                desc = "git hunk stage",
            },
            {
                "<leader>hu",
                function() require("gitsigns").reset_hunk() end,
                desc = "git hunk undo",
            },
            {
                "<leader>hp",
                function() require("gitsigns").preview_hunk_inline() end,
                desc = "git hunk preview",
            },
            {
                "<leader>hb",
                function() require("gitsigns").blame_line({ full = true }) end,
                desc = "git hunk blame",
            },
            {
                "<leader>hh",
                function() require("gitsigns").toggle_current_line_blame() end,
                desc = "git toggle current line blame",
            },
            {
                "<leader>hg",
                function()
                    require("gitsigns").toggle_linehl()
                    require("gitsigns").toggle_word_diff()
                end,
                desc = "git hunk gutter",
            },
            {
                "]c",
                function() require("gitsigns").nav_hunk("next") end,
                desc = "git hunk next",
            },
            {
                "[c",
                function() require("gitsigns").nav_hunk("prev") end,
                desc = "git hunk prev",
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        cmd = "DiffviewOpen",
    },
}
