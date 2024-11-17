vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4

if vim.api.nvim_buf_get_name(0):match("spec.lua") then
    vim.keymap.set("n", "<leader>go", ":PlenaryBustedFile %<CR>", { noremap = true, buffer = true })
else
    vim.keymap.set("n", "<leader>go", ":luafile %<CR>", { buffer = true })
end
