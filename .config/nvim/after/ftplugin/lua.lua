vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4

vim.keymap.set("n", "<leader>x", ":luafile %<CR>", { buffer = true })
vim.keymap.set("v", "<leader>x", ":'<,'>lua<CR>", { buffer = true })

if vim.api.nvim_buf_get_name(0):match("spec.lua") then
    vim.keymap.set("n", "<leader>x", ":PlenaryBustedFile %<CR>", { noremap = true, buffer = true })
end
