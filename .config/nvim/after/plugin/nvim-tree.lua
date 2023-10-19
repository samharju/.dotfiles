-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
local ntree = require("nvim-tree")


ntree.setup {
    view = {
        float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = {
                width = 35,
            }
        }
    },
    filters = {
        git_ignored = false
    },
    renderer = {
        icons = {
            git_placement = "after",
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
                chars = "AJKLSDF",
            }
        }
    }
}

vim.keymap.set("n", "<leader>v", ":NvimTreeFindFileToggle<CR>")
