return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            settings = {
                save_on_toggle = true,
            },
        })

        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<leader>x", function()
                    local keep = {}
                    for _, item in ipairs(harpoon:list().items) do
                        keep[item.value] = true
                    end

                    local bufs = vim.api.nvim_list_bufs()
                    for _, buf in ipairs(bufs) do
                        if
                            vim.api.nvim_buf_is_loaded(buf)
                            and vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "harpoon"
                            and vim.api.nvim_get_option_value("buflisted", { buf = buf })
                        then
                            local f = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")

                            if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                                vim.notify("Not closing " .. f .. " because it is modified")
                            elseif not keep[f] then
                                vim.api.nvim_buf_delete(buf, { force = false })
                                if f == "" then f = "[No Name]" end
                                vim.notify("Closed buffer: " .. f)
                            end
                        end
                    end
                    harpoon.ui:close_menu()
                end, { buffer = cx.bufnr })
            end,
        })

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "harpoonfile 1" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "harpoonfile 2" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "harpoonfile 3" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "harpoonfile 4" })
    end,
}
