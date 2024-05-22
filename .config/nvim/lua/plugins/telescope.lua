return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local function custom_path(_, path)
            local fname = vim.fs.basename(path)
            local parent = vim.fs.dirname(path)
            if parent == "." then return fname end
            return string.format("%s > %s", fname, parent)
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "TelescopeResults",
            callback = function(ctx)
                vim.api.nvim_buf_call(ctx.buf, function()
                    vim.fn.matchadd("TelescopeParent", " > .*$")
                    vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
                end)
            end,
        })

        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "%.git/" },
                path_display = { "smart" },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    results_title = false,
                    previewer = false,
                    path_display = custom_path,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    results_title = false,
                    mappings = {
                        n = {
                            ["x"] = require("telescope.actions").delete_buffer,
                        },
                    },
                },
                current_buffer_fuzzy_find = {
                    theme = "ivy",
                    previewer = false,
                    results_title = false,
                },
            },
        })
    end,
    keys = {
        {
            "<leader>ff",
            function() require("telescope.builtin").find_files({ prompt_title = "Files", hidden = true }) end,
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
            "<leader>fz",
            function() require("telescope.builtin").current_buffer_fuzzy_find() end,
            desc = "tele current_buffer_fuzzy_find",
        },
        {
            "<leader>fi",
            function() require("telescope.builtin").highlights() end,
            desc = "tele highlights",
        },
    },
}
