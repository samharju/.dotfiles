return {
    {
        "samharju/yeet.nvim",
        opts = {
            clear_before_yeet = false,
            retry_last_target_on_failure = true,
            hide_term_buffers = true,
        },
        keys = {
            {
                "<leader><BS>",
                function() require("yeet").list_cmd() end,
            },
            {
                "\\\\",
                function() require("yeet").execute() end,
            },
            {
                "<leader>\\",
                function()
                    require("yeet").execute(nil, {
                        interrupt_before_yeet = true,
                        clear_before_yeet = true,
                    })
                end,
            },
            {
                "\\\\",
                function() require("yeet").execute_selection() end,
                mode = { "v" },
            },
            {
                "<leader>yt",
                function() require("yeet").select_target() end,
            },
            {
                "<leader>yo",
                function() require("yeet").toggle_post_write() end,
            },
            {
                "<leader>ye",
                function() require("yeet").setqflist({ open = true }) end,
            },
        },
    },
}
