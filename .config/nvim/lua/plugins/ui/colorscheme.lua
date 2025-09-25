local colors = {
    "blue",
    "darkblue",
    "default",
    "delek",
    "desert",
    "elflord",
    "evening",
    "habamax",
    "industry",
    "koehler",
    "lunaperche",
    "morning",
    "murphy",
    "pablo",
    "peachpuff",
    "quiet",
    "quitequiet",
    "quitequiet-transparent",
    "retrobox",
    "ron",
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
    { "samharju/synthweave.nvim", dev = true },
    { "samharju/serene.nvim" },
    { "samharju/quitequiet.nvim", dev = true },
}
