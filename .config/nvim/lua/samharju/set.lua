vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.opt.backup = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.expandtab = true
vim.opt.guicursor = "n-c-sm:block,v:hor20,i-ci-ve:ver25,r-cr-o:hor20-blinkon175-blinkoff150-blinkwait175"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.isfname:append('@-@')
vim.opt.listchars:append 'eol:↴'
vim.opt.listchars:append 'trail:⋅'
vim.opt.list = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.signcolumn = 'yes'
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false

vim.diagnostic.config {
    virtual_text = { source = 'if_many' },
    severity_sort = true,
    float = {
        source = 'always'
    }
}


-- vim.keymap.set({ "n", "v" }, "<leader>hh", function()
--     local _, _, start, _ = vim.fn.getpos("'<")
--     local _, _, stop, _ = vim.fn.getpos("'>")
--     print(start .. stop)
-- end)
