return {
    "samharju/yeet.nvim",
    dev = true,
    opts = {},
    keys = {
        {
            "<leader>yt",
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
            "<leader>\\",
            function() require("yeet").execute(nil, { clear_before_yeet = false }) end,
        },
        {
            "<leader>ya",
            function() require("yeet").toggle_post_write() end,
        },
        {
            "<leader><BS>",
            function() require("yeet").list_cmd() end,
        },
    },
    cmd = "Yeet",
}
