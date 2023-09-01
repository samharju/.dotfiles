-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
local ntree = require("nvim-tree")


ntree.setup {
    view = {
        side = "right",
        width = 50,
        -- float = {
        --     enable = true,
        --     quit_on_focus_loss = false,
        --     open_win_config = {
        --         relative = "cursor",
        --         border = "rounded",
        --         width = 30,
        --         height = 30,
        --         row = 1,
        --         col = 1,
        --     },
        -- }
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        icons = {
            git_placement = "after",
            modified_placement = "after"
        },
        highlight_git = true,
        highlight_opened_files = "icon",
    },
    update_focused_file = {
        enable = true
    },
    diagnostics = {
        enable = true
    },
    modified = {
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
