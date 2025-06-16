vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "

vim.opt.backup = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.expandtab = true
vim.opt.guicursor = "n-c-sm:block,v:hor20,i-ci-ve:ver25,r-cr-o:hor20-blinkon175-blinkoff150-blinkwait175"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.listchars = { eol = "↴", trail = "·", nbsp = "+", tab = "» ", leadmultispace = "›   " }
vim.opt.list = true
vim.opt.nu = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase  = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.clipboard = "unnamedplus"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldenable = true
vim.o.foldlevel = 10
vim.opt.textwidth = 0
vim.opt.grepprg = "rg --vimgrep --hidden --smart-case"

local signs = {
    [vim.diagnostic.severity.ERROR] = "󰚌 ",
    [vim.diagnostic.severity.WARN] = "󰯈 ",
    [vim.diagnostic.severity.INFO] = "󰋼 ",
    [vim.diagnostic.severity.HINT] = "󰩔 ",
}

vim.diagnostic.config({
    underline = true,
    signs = false,
    virtual_text = {
        format = function(diag)
            -- get only text to first newline
            local message = diag.message:match("[^\n]*")
            if #message < 10 then message = diag.source end
            return message
        end,
        source = "if_many",
        prefix = function(diag, i, t)
            if t > 1 and i ~= t then return "" end
            return signs[diag.severity]
        end,
    },
    severity_sort = true,
    float = {
        header = "",
        source = true,
        border = "rounded",
        prefix = "",
    },
})
