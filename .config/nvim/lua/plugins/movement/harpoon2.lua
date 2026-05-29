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
                key = function()
                    if vim.g.harpoon_branch then return vim.loop.cwd() .. "-" .. (vim.g.gitsigns_head or "") end
                    return vim.loop.cwd()
                end,
            },
        })

        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "g?", function()
                    for _, v in ipairs(vim.api.nvim_buf_get_keymap(cx.bufnr, "n")) do
                        vim.print("'" .. v.lhs .. "' " .. (v.desc or ""))
                    end
                end, { buffer = cx.bufnr, desc = "show mappings" })

                vim.keymap.set("n", "<leader>x", function()
                    local keep = {}
                    for _, item in ipairs(harpoon:list().items) do
                        keep[vim.fn.fnamemodify(item.value, ":.")] = true
                    end

                    local bufs = vim.api.nvim_list_bufs()
                    for _, buf in ipairs(bufs) do
                        if
                            vim.api.nvim_buf_is_loaded(buf)
                            and vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "harpoon"
                            and vim.api.nvim_get_option_value("buflisted", { buf = buf })
                        then
                            local f = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                            if not keep[f] then
                                if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                                    vim.notify("Not closing " .. f .. " because it is modified")
                                else
                                    vim.api.nvim_buf_delete(buf, { force = false })
                                    if f == "" then f = "[No Name]" end
                                    vim.notify("Closed buffer: " .. f)
                                end
                            end
                        end
                    end
                    vim.cmd.wincmd("=")
                    harpoon.ui:close_menu()
                end, { buffer = cx.bufnr, desc = "close other buffers" })

                vim.keymap.set("n", "<leader>a", function()
                    for i, item in ipairs(harpoon:list().items) do
                        if i < 4 then
                            vim.cmd("botright vsplit " .. item.value)
                        else
                            vim.cmd("belowright split " .. item.value)
                        end
                    end
                    vim.cmd.wincmd("=")
                    harpoon.ui:close_menu()
                end, { buffer = cx.bufnr, desc = "open harpoon files" })
            end,
        })

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<leader>t", function()
            vim.g.harpoon_branch = not vim.g.harpoon_branch
            vim.print("harpoon using branch: ", tostring(vim.g.harpoon_branch))
        end)

        vim.keymap.set("n", "<leader>j", function() harpoon:list():select(1) end, { desc = "harpoonfile 1" })
        vim.keymap.set("n", "<leader>k", function() harpoon:list():select(2) end, { desc = "harpoonfile 2" })
        vim.keymap.set("n", "<leader>l", function() harpoon:list():select(3) end, { desc = "harpoonfile 3" })
        vim.keymap.set("n", "<leader>,", function() harpoon:list():prev() end, { desc = "harpoonfile prev" })
        vim.keymap.set("n", "<leader>.", function() harpoon:list():next() end, { desc = "harpoonfile next" })
    end,
}
