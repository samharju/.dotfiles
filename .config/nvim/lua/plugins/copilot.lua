return {
    {
        "gptlang/CopilotChat.nvim",
        enabled = os.getenv("USE_COPILOT") == "true",
        after = {
            "zbirenbaum/copilot.lua",
        },
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        enabled = os.getenv("USE_COPILOT") == "true",
        cmd = "Copilot",
        opts = {
            panel = {
                enabled = false,
                auto_refresh = false,
                keymap = {
                    jump_prev = "<M-[>",
                    jump_next = "<M-]>",
                    accept = "<M-\\>",
                    refresh = "<M-=>",
                    open = "<M-BS>",
                },
                layout = {
                    position = "right", -- | top | left | right
                    ratio = 0.4,
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<M-\\>",
                    accept_word = "<M-'>",
                    accept_line = "<M-;>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                sh = function()
                    if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                        -- disable for .env files
                        return false
                    end
                    return true
                end,
                ["."] = false,
            },
            copilot_node_command = "node", -- Node.js version must be > 18.x
            server_opts_overrides = {
                settings = {
                    advanced = { inlineSuggestCount = 3 },
                },
            },
        },
    },
}
