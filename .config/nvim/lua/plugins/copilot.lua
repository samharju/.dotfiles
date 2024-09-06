return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        enabled = os.getenv("USE_COPILOT") == "true",
        dependecies = {
            "github/copilot.vim",
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        opts = {
            prompts = {
                Buffer = "@buffer",
                Buffers = "@buffers",
            },
        },
        cmd = "CopilotChat",
        keys = {
            { "<leader>cc", ":CopilotChat<CR>" },
        },
    },
    {
        "github/copilot.vim",
        enabled = os.getenv("USE_COPILOT") == "true",
        config = function()
            vim.cmd([[ Copilot enable ]])
            vim.g.copilot_no_tab_map = true
            vim.keymap.set("i", "<M-\\>", "copilot#Accept()", {
                expr = true,
                replace_keycodes = false,
            })
        end,
    },
}
