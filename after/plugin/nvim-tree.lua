-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup{
    view = {
        width = {},
        float = {
        enable = true
    }
    },
    renderer = {
        icons = {
            git_placement = "after"
        },
        highlight_git = true
    }
}


vim.keymap.set("n", "<leader>pv", ":NvimTreeFindFile<CR>")

local function open_nvim_tree()

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
