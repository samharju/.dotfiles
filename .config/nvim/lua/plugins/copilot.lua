return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        enabled = os.getenv("USE_COPILOT") == "true",
        dependecies = {
            "zbirenbaum/copilot.lua",
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        opts = {
            show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
            debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
            disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
            language = "English", -- Copilot answer language settings when using default prompts. Default language is English.
            -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
            -- temperature = 0.1,
            prompts = {
                Explain = "Explain this code to me very briefly.",
                Review = "Review the following code and provide brief suggestions.",
                Tests = "Generate unit tests for this code.",
                Refactor = "Refactor the code to improve clarity and readability.",
            },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        enabled = os.getenv("USE_COPILOT") == "true",
        cmd = "Copilot",
        opts = {
            panel = {
                enabled = true,
                auto_refresh = true,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "<M-]>",
                    open = "<M-p>",
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
                yaml = true,
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
