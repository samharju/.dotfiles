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
                    n = { ["<leader>n"] = require("telescope.actions.layout").toggle_preview },
                },
                layout_config = {
                    height = 0.5,
                },
            }),
            pickers = {
                find_files = {
                    hidden = true,
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
                require("telescope.builtin").git_status({
                    attach_mappings = function(_, map)
                        map("i", "<cr>", function(prompt_bufnr)
                            local entry = require("telescope.actions.state").get_selected_entry()
                            require("telescope.actions").close(prompt_bufnr)
                            vim.cmd.e(entry.value)
                            vim.defer_fn(function() require("gitsigns").next_hunk() end, 500)
                        end)
                        return true
                    end,
                })
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

                        local prompt_args = vim.split(prompt, ":", { trimempty = true })
                        local args = { "rg" }
                        if #prompt_args == 2 then
                            table.insert(args, "-g")
                            table.insert(args, prompt_args[1])

                            table.insert(args, "-e")
                            table.insert(args, prompt_args[2])
                        else
                            return nil
                        end

                        return vim.iter({
                            args,
                            {
                                "--color=never",
                                "--no-heading",
                                "--with-filename",
                                "--line-number",
                                "--column",
                                "--smart-case",
                            },
                        })
                            :flatten()
                            :totable()
                    end,
                    entry_maker = make_entry.gen_from_vimgrep(opts),
                    cwd = opts.cwd,
                })

                pickers
                    .new(opts, {
                        debounce = 100,
                        prompt_title = "Grep <glob>:<pattern>",
                        finder = finder,
                        previewer = conf.grep_previewer(opts),
                        sorter = require("telescope.sorters").empty(),
                    })
                    :find()
            end,
        },
    },
}
