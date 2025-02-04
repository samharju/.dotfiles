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

vim.api.nvim_create_user_command("NotesNew", function()
    local fname = vim.fn.input({
        prompt = "Note name: ",
        default = os.date("%Y-%m-%d") .. ".md",
    })
    local p = vim.fn.expand("~/notes/" .. fname)
    os.execute("mkdir -p " .. vim.fn.fnamemodify(p, ":p:h"))
    vim.cmd.e(p)
end, {})

vim.api.nvim_create_user_command(
    "NotesGrep",
    function()
        require("telescope.builtin").live_grep({
            no_ignore = true,
            hidden = true,
            prompt_title = "Notes",
            cwd = "~/notes",
        })
    end,
    {}
)
