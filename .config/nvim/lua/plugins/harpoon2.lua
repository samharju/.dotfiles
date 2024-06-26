return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "samharju/yeet.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "harpoonfile 1" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "harpoonfile 2" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "harpoonfile 3" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "harpoonfile 4" })
        vim.keymap.set("n", "<leader>j", function() harpoon:list():prev() end, { desc = "harpoon prev" })
        vim.keymap.set("n", "<leader>l", function() harpoon:list():next() end, { desc = "harpoon next" })
    end,
}
