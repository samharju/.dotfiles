return {
    "stevearc/quicker.nvim",
    event = "VeryLazy",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
        -- opts = { wrap = true },
        type_icons = {
            E = "󰚌 ",
            W = "󰯈 ",
            I = "󰋼 ",
            N = "󰩔 ",
            H = "󰩔 ",
        },
        max_filename_width = function() return math.floor(math.max(25, vim.o.columns / 4)) end,
        keys = {
            {
                ">",
                function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
                desc = "Expand quickfix context",
            },
            {
                "<",
                function() require("quicker").collapse() end,
                desc = "Collapse quickfix context",
            },
        },
    },
}
