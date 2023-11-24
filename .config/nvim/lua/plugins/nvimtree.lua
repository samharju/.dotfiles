return {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    keys = {
        { '<leader>v', ':NvimTreeFindFileToggle<CR>', desc = 'nvimtree toggle', silent = true }
    },
    opts = {
        hijack_cursor = true,
        view = {
            float = {
                enable = false,
                quit_on_focus_loss = false,
            },
            signcolumn = "yes",
            width = {} -- empty table means adaptive
        },
        renderer = {
            icons = {
                git_placement = 'after',
                glyphs = {
                    git = { ignored = "" }
                }
            },
            highlight_diagnostics = true,
            highlight_git = true,
        },
        update_focused_file = {
            enable = true
        },
        diagnostics = {
            enable = true,
            show_on_open_dirs = true
        },
        actions = {
            open_file = {
                quit_on_open = true,
                window_picker = {
                    chars = 'AJKLSDF',
                }
            }
        }
    }
}
