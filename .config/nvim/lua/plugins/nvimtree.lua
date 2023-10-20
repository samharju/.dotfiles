return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    keys = {
        { '<leader>v', ':NvimTreeFindFileToggle<CR>', desc = 'nvimtree toggle' }
    },
    opts = {
        view = {
            float = {
                enable = true,
                quit_on_focus_loss = true,
            }
        },
        filters = {
            git_ignored = false
        },
        renderer = {
            icons = {
                git_placement = 'after',
            },
            highlight_git = true,
        },
        update_focused_file = {
            enable = true
        },
        diagnostics = {
            enable = true
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
