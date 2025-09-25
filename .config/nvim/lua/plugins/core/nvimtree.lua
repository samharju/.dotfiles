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
                    local h = math.floor(vim.o.lines * 0.8)
                    local row = math.floor((vim.o.lines - h) / 2) - 2
                    local w = math.floor(vim.o.columns * 0.8)
                    local col = math.floor((vim.o.columns - w) / 2)
                    return {
                        relative = "editor",
                        border = "rounded",
                        width = w,
                        height = h,
                        row = row,
                        col = col,
                    }
                end,
            },
            signcolumn = "yes",
        },
        renderer = {
            indent_width = 8,
            icons = {
                git_placement = "after",
                show = {
                    folder = false,
                    folder_arrow = false,
                },
            },
            add_trailing = true,
            highlight_diagnostics = "all",
            highlight_git = "all",
            highlight_hidden = "all",
            group_empty = true,
            -- indent_markers = {
            --     enable = true,
            --     inline_arrows = false,
            -- },
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
            git_ignored = false,
            custom = {
                "\\.git$",
                -- "\\.mypy_cache",
                -- "\\.pytest_cache",
                -- "\\.vscode",
                -- "\\.idea",
                -- "__pycache__",
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
