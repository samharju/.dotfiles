require("harpoon").setup({
    enter_on_sendcmd = true,
    tabline = true,
    tabline_prefix = "   ",
    tabline_suffix = "",
})


local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "harpoonfile 1" })
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "harpoonfile 2" })
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "harpoonfile 3" })
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "harpoonfile 4" })
vim.keymap.set("n", "<leader>n", ui.nav_next, { desc = "harpoon next" })

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')


vim.keymap.set("n", "<leader><BS>", require("harpoon.cmd-ui").toggle_quick_menu)
vim.keymap.set("n", "\\", function()
    require("harpoon.term").sendCommand(1, "clear")
    require("harpoon.term").sendCommand(1, 1)
end, { desc = "harpoon run first command" })
