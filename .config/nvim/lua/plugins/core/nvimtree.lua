return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>v", ":NvimTreeFindFileToggle<CR>", desc = "nvimtree toggle", silent = true },
    },
    opts = {
        hijack_cursor = true,
        view = {
            float = {
                enable = true,
                quit_on_focus_loss = true,
                open_win_config = function()
                    return {
                        relative = "editor",
                        border = "rounded",
                        width = 80,
                        height = vim.o.lines - 7,
                        row = 3,
                        col = 3,
                    }
                end,
            },
            signcolumn = "yes",
        },
        renderer = {
            icons = {
                git_placement = "after",
                glyphs = {
                    git = { ignored = "" },
                },
                show = {
                    folder = false,
                },
            },
            highlight_diagnostics = true,
            highlight_git = true,
            group_empty = true,
        },
        update_focused_file = {
            enable = true,
        },
        actions = {
            open_file = {
                quit_on_open = true,
                window_picker = {
                    chars = "AJKLSDF",
                },
            },
            change_dir = {
                global = true,
            },
        },
        filters = {
            git_ignored = true,
            custom = {
                "\\.git$",
                "\\.mypy_cache",
                "\\.pytest_cache",
                "\\.vscode",
                "\\.idea",
                "__pycache__",
            },
        },
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            api.config.mappings.default_on_attach(bufnr)

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
            vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        end,
    },
}
