-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
local ntree = require("nvim-tree")
local api = require("nvim-tree.api")


ntree.setup {
    view = {
        width = {},
        float = {
            enable = true
        }
    },
    renderer = {
        --        icons = {
        --            git_placement = "after"
        --        },
        highlight_git = true,
        highlight_opened_files = "icon"
    },
    update_focused_file = {
        enable = true
    },
    diagnostics = {
        enable = true
    }
}

vim.keymap.set("n", "<leader>v", ":NvimTreeFindFile<CR>")

local function open_nvim_tree(data)
    -- open the tree if directory, change nvim root
    local directory = vim.fn.isdirectory(data.file) == 1
    if directory then
        vim.cmd.cd(data.file)
    end

    -- open the tree if empty buffer
    if directory or (data.file == "" and vim.bo[data.buf].buftype == "") then
        api.tree.open({ focus = true, find_file = true })
    end
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
