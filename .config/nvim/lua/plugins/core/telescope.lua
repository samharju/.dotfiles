local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")

    return vim.v.shell_error == 0
end

local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
end

local cwd = nil

if is_git_repo() then cwd = get_git_root() end

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
                lsp_references = {
                    layout_strategy = "vertical",
                    include_declaration = false,
                    fname_width = 50,
                },
            },
        })
    end,
    keys = {
        {
            "<leader>ff",
            (function()
                local cmd = (function()
                    local test = vim.system({ "git", "config", "--local", "core.excludesfile" }, { text = true }):wait()
                    if test.code == 0 and test.stdout ~= "" then
                        local file = test.stdout:gsub("%s+", "")
                        return { "rg", "--files", "--color", "never", "--ignore-file", file }
                    end
                    return { "rg", "--files", "--color", "never" }
                end)()

                return function() require("telescope.builtin").find_files({ cwd = cwd, find_command = cmd }) end
            end)(),

            desc = "tele find_files",
        },
        {
            "<leader>fa",
            function()
                require("telescope.builtin").find_files({
                    no_ignore = true,
                    hidden = true,
                    prompt_title = "All files, no ignore",
                    cwd = cwd,
                })
            end,
            desc = "tele find_files no ignore",
        },
        {
            "<leader>fd",
            function() require("telescope.builtin").diagnostics({ cwd = cwd }) end,
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
            function() require("telescope.builtin").git_files({ layout_strategy = "vertical", previewer = false }) end,
            desc = "tele git files",
        },
        {
            "<leader>fk",
            function() require("telescope.builtin").keymaps() end,
            desc = "tele keymaps",
        },
        {
            "<leader>fl",
            function()
                local opts = function()
                    local test = vim.system({ "git", "config", "--local", "core.excludesfile" }, { text = true }):wait()
                    if test.code == 0 and test.stdout ~= "" then
                        local file = test.stdout:gsub("%s+", "")
                        return { "--ignore-file", file }
                    end
                    return {}
                end

                require("telescope.builtin").live_grep({ additional_args = opts() })
            end,
            desc = "tele live_grep",
        },
        {
            "<leader>fs",
            function() require("telescope.builtin").grep_string({ cwd = cwd }) end,
            desc = "tele grep_string",
        },
        {
            "<leader>ft",
            function()
                require("telescope.builtin").grep_string({
                    cwd = cwd,
                    search = [[TODO|FIXME|\bFIX\b|\\bbbreakpoint\(\)]],
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
    },
}
