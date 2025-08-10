vim.keymap.set("i", "jk", "<ESC>")

-- wrap selection into quotes
vim.keymap.set("v", "<leader>s'", "c'<C-r>\"'<Esc>")
vim.keymap.set("v", '<leader>s"', 'c"<C-r>""<Esc>')
vim.keymap.set("v", "<leader>s(", 'c(<C-r>")<Esc>')
vim.keymap.set("v", "<leader>s[", 'c[<C-r>"]<Esc>')
vim.keymap.set("v", "<leader>s{", 'c{<C-r>"}<Esc>')

-- move block nicely
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- keep stuff centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>P", '"+P')

vim.keymap.set("n", "<leader>i", ":Inspect<CR>")

local nustate = 2
vim.keymap.set("n", "<leader>'", function()
    if nustate == 2 then
        nustate = 0
    else
        nustate = nustate + 1
    end

    if nustate == 0 then
        vim.o.number = false
        vim.o.relativenumber = false
    elseif nustate == 1 then
        vim.o.number = true
        vim.o.relativenumber = true
    else
        vim.o.number = true
        vim.o.relativenumber = false
    end
end)

-- back and forth
vim.keymap.set("n", "<leader>;", "<C-^>", { desc = "alt buffer" })

vim.keymap.set("n", "<leader>w", vim.diagnostic.open_float, { desc = "Open diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Diagnostic qf" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Diagnostic qf" })

-- lsp 0.11 ,appings:
-- grn N vim.lsp.buf.rename()
-- grr N vim.lsp.buf.references()
-- gri N vim.lsp.buf.implementation()
-- gO  N vim.lsp.buf.document_symbol()
-- gra NV vim.lsp.buf.code_action()
-- grt N vim.lsp.buf.type_definition()
vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set({ "n", "i", "s" }, "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end)
