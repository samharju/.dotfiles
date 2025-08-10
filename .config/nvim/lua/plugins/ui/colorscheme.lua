local colors = {
    "bloom",
    "bloom-transparent",
    "blue",
    "darkblue",
    "daymode",
    "default",
    "delek",
    "desert",
    "elflord",
    "evening",
    "habamax",
    "industry",
    "koehler",
    "lunaperche",
    "moonfly",
    "morning",
    "murphy",
    "pablo",
    "peachpuff",
    "quiet",
    "quitequiet",
    "quitequiet-transparent",
    "retrobox",
    "ron",
    "rose-pine",
    "rose-pine-dawn",
    "rose-pine-main",
    "rose-pine-moon",
    "serene",
    "serene-transparent",
    "shine",
    "slate",
    "sorbet",
    "synthweave",
    "synthweave-transparent",
    "torte",
    "vim",
    "wildcharm",
    "zaibatsu",
    "zellner",
}

math.randomseed(os.time())
local i = math.random(1, #colors)

local function cc()
    if i == #colors then i = 0 end
    i = i + 1
    vim.o.background = "dark"
    vim.cmd.colorscheme(colors[i])
    vim.notify("colorscheme: " .. colors[i])
end

vim.keymap.set("n", "<leader>cn", cc)

return {
    { "rose-pine/neovim", name = "rose-pine" },
    { "samharju/synthweave.nvim" },
    { "samharju/serene.nvim" },
    { "samharju/quitequiet.nvim", dev = true },
    { "bluz71/vim-moonfly-colors" },
}
