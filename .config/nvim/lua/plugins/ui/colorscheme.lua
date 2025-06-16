local colors = {
    "serene",
    "serene-transparent",
    "sorbet",
    "zaibatsu",
    "synthweave",
    "synthweave-transparent",
    "rose-pine-main",
    "retrobox",
    "rose-pine-moon",
    "wildcharm",
    "habamax",
    "slate",
    "lunaperche",
    "default",
    "moonfly",
    "quitequiet",
}

math.randomseed(os.time())
local i = math.random(1, #colors)

local function cc()
    if i == #colors then i = 0 end
    i = i + 1
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
