return {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
        -- Your setup opts here
        outline_window = { position = "left", relative_width = false, width = 60 },
        symbols = { filter = { "Function", "Class", "Method", "Constant", "Struct" } },
    },
}
