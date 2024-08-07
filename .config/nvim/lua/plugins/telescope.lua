return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- local function custom_path(_, path)
        --     local tail = require("telescope.utils").path_tail(path)
        --     return string.format("%s > %s", tail, path)
        -- end
        --
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = "TelescopeResults",
        --     callback = function(ctx)
        --         vim.api.nvim_buf_call(ctx.buf, function()
        --             vim.fn.matchadd("TelescopeParent", " > .*$")
        --             vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        --         end)
        --     end,
        -- })

        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "%.git/" },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    hidden = true,
                    prompt_title = vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    mappings = {
                        n = {
                            ["x"] = require("telescope.actions").delete_buffer,
                        },
                    },
                },
                current_buffer_fuzzy_find = {
                    previewer = false,
                    results_title = false,
                },
                live_grep = {
                    layout_strategy = "vertical",
                },
            },
        })
    end,
    keys = {
        {
            "<leader>ff",
            function() require("telescope.builtin").find_files() end,
            desc = "tele find_files",
        },
        {
            "<leader>fa",
            function()
                require("telescope.builtin").find_files({
                    no_ignore = true,
                    hidden = true,
                    prompt_title = "All files, no ignore",
                })
            end,
            desc = "tele find_files no ignore",
        },
        {
            "<leader>fd",
            function() require("telescope.builtin").diagnostics() end,
            desc = "tele diagnostics",
        },
        {
            "<leader>fe",
            function() require("telescope.builtin").buffers() end,
            desc = "tele buffers",
        },
        {
            "<leader>fg",
            function() require("telescope.builtin").git_status() end,
            desc = "tele git_status",
        },
        {
            "<leader>fh",
            function() require("telescope.builtin").help_tags() end,
            desc = "tele help_tags",
        },
        {
            "<leader>fk",
            function() require("telescope.builtin").keymaps() end,
            desc = "tele keymaps",
        },
        {
            "<leader>fl",
            function() require("telescope.builtin").live_grep() end,
            desc = "tele live_grep",
        },
        {
            "<leader>fs",
            function() require("telescope.builtin").grep_string() end,
            desc = "tele grep_string",
        },
        {
            "<leader>ft",
            function() require("telescope.builtin").grep_string({ search = [[TODO|FIXME|\bFIX]], use_regex = true }) end,
            desc = "tele todos",
        },
        {
            "<leader>fz",
            function() require("telescope.builtin").current_buffer_fuzzy_find() end,
            desc = "tele current_buffer_fuzzy_find",
        },
        {
            "<leader>fi",
            function() require("telescope.builtin").highlights() end,
            desc = "tele highlights",
        },
        {
            "<leader>fr",
            function() require("telescope.builtin").resume() end,
            desc = "tele resume last search",
        },
    },
}
