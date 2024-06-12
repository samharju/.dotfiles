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
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- exit normal mode in terminal emulator
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>P", '"+P')

-- iterate quick- and loclist
vim.keymap.set("n", "[q", ":cprev<CR>")
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[l", ":lprev<CR>")
vim.keymap.set("n", "]l", ":lnext<CR>")

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>w", vim.diagnostic.open_float, { desc = "Open diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Diagnostic qf" })

local grp = vim.api.nvim_create_augroup("sami_remap", { clear = true })

--- Define commands to run for specific filetypes with "go"
local run = {
    python = ":!python3 %<CR>",
    sh = ":!bash %<CR>",
    lua = ":luafile %<CR>",
}

vim.api.nvim_create_autocmd("FileType", {
    group = grp,
    callback = function()
        local c = run[vim.api.nvim_buf_get_option(0, "filetype")]
        if c ~= nil then vim.keymap.set("n", "<leader>go", c, { buffer = true }) end
    end,
})

--- Define lsp keymaps only on attach
vim.api.nvim_create_autocmd("LspAttach", {
    group = grp,
    callback = function(e)
        local opts = { buffer = e.buf }
        local tele = require("telescope.builtin")
        vim.keymap.set("n", "gd", tele.lsp_definitions, { buffer = e.buf, desc = "tele definitions" })
        vim.keymap.set("n", "gr", tele.lsp_references, { buffer = e.buf, desc = "tele references" })
        vim.keymap.set("n", "gi", tele.lsp_implementations, { buffer = e.buf, desc = "tele implementations" })
        vim.keymap.set(
            "n",
            "<leader>fw",
            function() tele.lsp_document_symbols({ symbol_width = 35 }) end,
            { buffer = e.buf, desc = "tele lsp_document_symbols" }
        )

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})

vim.keymap.set("n", "<leader>;", ":b#<CR>", { desc = "Previous buffer" })
vim.keymap.set({ "n", "v" }, "<leader>x", ":w !cat<CR>", { desc = "print selection" })

vim.keymap.set("n", "<leader>s", "<C-w>H:vert res 84<CR>")

vim.keymap.set("n", "<leader>i", ":Inspect<CR>")
