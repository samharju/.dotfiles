return {
    "samharju/yeet.nvim",
    opts = {},
    keys = {
        {
            "<leader>yo",
            function() require("yeet").select_target() end,
        },
        {
            "<leader>yc",
            function() require("yeet").set_cmd() end,
        },
        {
            "\\\\",
            function() require("yeet").execute() end,
        },
        {
            "<leader>ya",
            function() require("yeet").toggle_post_write() end,
        },
    },
    cmd = "Yeet",
}
