vim.api.nvim_create_user_command(
    "Notes",
    function()
        require("telescope.builtin").find_files({
            no_ignore = true,
            hidden = true,
            prompt_title = "Notes",
            cwd = "~/notes",
        })
    end,
    {}
)
