local colors = {
    "serene",
    "serene-transparent",
    "synthweave",
    "synthweave-transparent",
    "rose-pine-main",
    "rose-pine-moon",
    "eldritch",
    "sorbet",
    "zaibatsu",
    "retrobox",
    "habamax",
    "wildcharm",
    "lunaperche",
    "slate",
    "default",
    "koehler",
    "industry",
}

local i = 1

vim.keymap.set("n", "<leader>cn", function()
    if i == #colors then i = 0 end
    i = i + 1
    vim.cmd.colorscheme(colors[i])
end)

return {
    {
        "eldritch-theme/eldritch.nvim",
        opts = {},
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
    },
    {
        "samharju/synthweave.nvim",
        dev = true,
    },
    {
        "samharju/serene.nvim",
        config = function() vim.cmd([[ colorscheme serene ]]) end,
    },
}
