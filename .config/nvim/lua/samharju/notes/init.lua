vim.api.nvim_create_user_command("Notes", function()
    vim.cmd("vertical split ~/notes/" .. os.date("%Y-%m-%d") .. ".md")
end, {})
