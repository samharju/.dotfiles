return {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    keys = {
        { '<leader>v', ':NvimTreeFindFileToggle<CR>', desc = 'nvimtree toggle' }
    },
    opts = {
        hijack_cursor = true,
        view = {
            float = {
                enable = true,
                quit_on_focus_loss = true,
            },
            signcolumn = "yes",
            width = {} -- empty table means adaptive
        },
        filters = {
            git_ignored = false
        },
        renderer = {
            icons = {
                git_placement = 'signcolumn',
                glyphs = {
                    git = { ignored = "" }
                }
            },
            highlight_git = true,
        },
        update_focused_file = {
            enable = true
        },
        diagnostics = {
            enable = true,
            show_on_open_dirs = false
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
