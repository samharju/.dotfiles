return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "%.git/" },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    hidden = true,
                    layout_config = { width = 100, height = 20 },
                    prompt_title = vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
                },
                git_files = {
                    theme = "dropdown",
                    layout_config = { width = 100, height = 20 },
                    previewer = false,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    layout_config = { width = 100 },
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
            function() require("telescope.builtin").diagnostics(require("telescope.themes").get_ivy()) end,
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
            "<leader>fv",
            function() require("telescope.builtin").git_files() end,
            desc = "tele git files",
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
            function()
                require("telescope.builtin").grep_string({
                    search = [[TODO|FIXME|\bFIX\b|\bbreakpoint\(\)]],
                    use_regex = true,
                })
            end,
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
        {
            "<leader>fk",
            function()
                require("telescope.builtin").find_files({
                    hidden = false,
                    find_command = { "fd", "--type", "d", "--color", "never", "-d", "4" },
                    attach_mappings = function(_, map)
                        map("i", "<CR>", function(prompt_bufnr)
                            local entry = require("telescope.actions.state").get_selected_entry()
                            require("telescope.actions").close(prompt_bufnr)
                            vim.cmd("e " .. entry[1])
                        end)
                        return true
                    end,
                })
            end,
            desc = "tele folders",
        },
    },
}
