return {
    "L3MON4D3/LuaSnip",
    -- version = "v2.*",
    build = "make install_jsregexp",
    event = "VeryLazy",
    config = function()
        local ls = require("luasnip")
        ls.setup({ enable_autosnippets = true })

        require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/snippets" } })

        vim.keymap.set("i", "<C-n>", function()
            if ls.expandable() then
                ls.expand()
            elseif ls.choice_active() then
                ls.change_choice(1)
            end
        end)
    end,
}
