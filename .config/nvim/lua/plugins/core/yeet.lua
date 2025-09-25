local custom_eval = function(cmd_string)
    if cmd_string:match("<file>") then
        local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
        cmd_string = cmd_string:gsub("<file>", fname)
    end

    if cmd_string:match("<cword>") then cmd_string = cmd_string:gsub("<cword>", vim.fn.expand("<cword>")) end

    if cmd_string:match("<function>") then
        local func_name = function()
            ---@type TSNode|nil
            local node = vim.treesitter.get_node()
            while node ~= nil do
                local t = node:type()
                if t == "function_definition" or t == "function_declaration" or t == "class_definition" then
                    for _, v in ipairs(node:field("name")) do
                        local sl, sc, _ = node:start()
                        local el, ec, _ = node:end_()
                        vim.hl.range(
                            0,
                            vim.api.nvim_create_namespace(""),
                            "Visual",
                            { sl, sc },
                            { el, ec },
                            { timeout = 150 }
                        )
                        return vim.treesitter.get_node_text(v, 0)
                    end
                end
                node = node:parent()
            end
            return ""
        end
        cmd_string = cmd_string:gsub("<function>", func_name())
    end

    return cmd_string
end

return {
    {
        "samharju/yeet.nvim",
        opts = {
            clear_before_yeet = true,
            retry_last_target_on_failure = true,
            custom_eval = custom_eval,
        },
        dev = true,
        keys = {
            {
                "<leader><BS>",
                function() require("yeet").list_cmd() end,
            },
            {
                "<leader>x",
                function() require("yeet").execute() end,
            },
            {
                "<leader>x",
                function() require("yeet").execute_selection() end,
                mode = { "v" },
            },
            {
                "<leader>\\",
                function()
                    require("yeet").execute(nil, {
                        interrupt_before_yeet = false,
                        clear_before_yeet = false,
                    })
                end,
                mode = { "n" },
            },
            {
                "<leader>\\",
                function()
                    require("yeet").execute_selection({
                        interrupt_before_yeet = false,
                        clear_before_yeet = false,
                    })
                end,
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
            {
                "<leader>yd",
                function() require("yeet").efm_to_diagnostics() end,
            },
        },
    },
}
