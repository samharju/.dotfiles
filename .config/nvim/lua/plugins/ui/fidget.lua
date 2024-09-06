return {
    "j-hui/fidget.nvim",
    tag = "v1.2.0",
    event = "VeryLazy",
    opts = {
        notification = {
            override_vim_notify = true, -- Automatically override vim.notify() with Fidget
        },
    },
}
