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

-- back and forth
vim.keymap.set("n", "<leader>;", "<C-^>", { desc = "alt buffer" })

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>w", vim.diagnostic.open_float, { desc = "Open diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Diagnostic qf" })

local grp = vim.api.nvim_create_augroup("sami_remap", { clear = true })

--- Define lsp keymaps only on attach
vim.api.nvim_create_autocmd("LspAttach", {
    group = grp,
    callback = function(e)
        local opts = { buffer = e.buf }
        local tele = require("telescope.builtin")
        vim.keymap.set(
            "n",
            "<leader>fw",
            function() tele.lsp_document_symbols({ symbol_width = 35 }) end,
            { buffer = e.buf, desc = "tele lsp_document_symbols" }
        )

        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})
