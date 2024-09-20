local colors = {
    "serene",
    "serene-transparent",
    "eldritch",
    "sorbet",
    "zaibatsu",
    "synthweave",
    "synthweave-transparent",
    "rose-pine-main",
    "retrobox",
    "rose-pine-moon",
    "tokyonight-night",
    "wildcharm",
    "tokyonight-storm",
    "habamax",
    "tokyonight-moon",
    "slate",
    "lunaperche",
    "default",
    "moonfly",
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
    { "eldritch-theme/eldritch.nvim", opts = {} },
    { "rose-pine/neovim", name = "rose-pine" },
    { "samharju/synthweave.nvim", dev = true },
    { "samharju/serene.nvim", config = function() vim.cmd.colorscheme("serene") end },
    { "folke/tokyonight.nvim", opts = {} },
    { "bluz71/vim-moonfly-colors" },
}
