local function ivy(opts)
    opts = opts or {}

    local theme_opts = {
        theme = "customivy",
        sorting_strategy = "ascending",
        layout_strategy = "bottom_pane",
        layout_config = {
            height = 0.5,
        },
        border = true,
        borderchars = {
            prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
            results = { " " },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
    }
    if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
        theme_opts.borderchars = {
            prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
            results = { "─", " ", " ", " ", "─", "─", " ", " " },
            preview = { "─", " ", "─", "│", "┬", "─", "─", "╰" },
        }
    end

    return vim.tbl_deep_extend("force", theme_opts, opts)
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = require("telescope.themes").get_ivy({
                file_ignore_patterns = { "%.git/" },
                preview = { hide_on_startup = true },
                mappings = {
                    n = { ["<leader>p"] = require("telescope.actions.layout").toggle_preview },
                },
                layout_config = {
                    height = 0.5,
                },
            }),
            pickers = {
                find_files = {
                    hidden = false,
                    prompt_title = vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
                },
                buffers = {
                    mappings = {
                        n = {
                            ["d"] = require("telescope.actions").delete_buffer,
                        },
                    },
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
            function()
                pcall(function()
                    require("telescope.builtin").git_status({
                        attach_mappings = function(_, map)
                            map("i", "<cr>", function(prompt_bufnr)
                                local entry = require("telescope.actions.state").get_selected_entry()
                                require("telescope.actions").close(prompt_bufnr)
                                vim.cmd.e(entry.value)
                                vim.defer_fn(function() require("gitsigns").nav_hunk("first") end, 500)
                            end)
                            return true
                        end,
                    })
                end)
            end,
            desc = "tele git_status",
        },
        {
            "<leader>fh",
            function() require("telescope.builtin").help_tags() end,
            desc = "tele help_tags",
        },
        {
            "<leader>fv",
            function()
                pcall(function() require("telescope.builtin").git_files() end)
            end,
            desc = "tele git files",
        },
        {
            "<leader>fm",
            function()
                pcall(function()
                    local out = vim.system({
                        "git",
                        "merge-base",
                        "--fork-point",
                        "refs/remotes/origin/HEAD",
                        "HEAD",
                    }, { text = true }):wait()

                    if out.code ~= 0 then
                        vim.print("git merge-base --fork-point refs/remotes/origin/HEAD HEAD\n" .. out.stderr)
                        return
                    end

                    local sha = string.gsub(out.stdout, "\n", "")

                    require("telescope.builtin").git_files({
                        git_command = { "git", "diff", sha, "HEAD", "--name-only" },
                    })
                end)
            end,
            desc = "tele git files",
        },
        {
            "<leader>fl",
            function() require("telescope.builtin").live_grep() end,
            desc = "tele live_grep",
        },
        {
            "<leader>fk",
            function() require("telescope.builtin").treesitter({ ignore_symbols = { "var", "parameter" } }) end,
            desc = "tele treesitter",
        },
        {
            "<leader>fs",
            function() require("telescope.builtin").grep_string() end,
            desc = "tele grep_string",
        },
        {
            "<leader>fb",
            function()
                pcall(function() require("telescope.builtin").git_branches() end)
            end,

            desc = "tele git_branches",
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
            "<leader>fj",
            function()
                local pickers = require("telescope.pickers")
                local finders = require("telescope.finders")
                local make_entry = require("telescope.make_entry")
                local conf = require("telescope.config").values
                local opts = { cwd = vim.uv.cwd(), layout_config = { width = 0.95 } }

                local finder = finders.new_async_job({
                    command_generator = function(prompt)
                        if not prompt or prompt == "" then return nil end

                        local glob, pattern = string.match(prompt, "(.-) (.*)")
                        if not glob or not pattern then return end

                        return {
                            "rg",
                            "-g",
                            glob .. "*",
                            "-e",
                            pattern,
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                        }
                    end,
                    entry_maker = make_entry.gen_from_vimgrep(opts),
                    cwd = opts.cwd,
                })

                pickers
                    .new(opts, {
                        debounce = 100,
                        prompt_title = "Grep <glob><space><pattern>",
                        finder = finder,
                        previewer = conf.grep_previewer(opts),
                        sorter = require("telescope.sorters").empty(),
                    })
                    :find()
            end,
        },
    },
}
