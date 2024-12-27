vim.keymap.set("n", "<leader>x", ":!bash %<CR>", { buffer = true })

if vim.fn.expand("%:t"):match("%.env") then vim.diagnostic.enable(false) end
