return {
    dir = "~/plugins/samharju/yeet.nvim",
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
    },
    cmd = "Yeet",
}
