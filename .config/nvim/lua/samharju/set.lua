vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "

vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.grepprg = "rg --vimgrep --hidden --smart-case"
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.termguicolors = true

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.smartcase = true

vim.opt.cursorcolumn = false
vim.opt.cursorline = true
vim.opt.guicursor = "n-c-sm:block,v:hor20,i-ci-ve:ver25,r-cr-o:hor20-blinkon175-blinkoff150-blinkwait175"
vim.opt.laststatus = 3
vim.opt.nu = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 2
vim.opt.signcolumn = "yes"
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.linebreak = true
vim.opt.wrap = true
vim.o.breakindent = true

vim.opt.listchars = { eol = "↴", trail = "·", nbsp = "+", tab = "» ", leadmultispace = "›   " }
vim.opt.list = true

vim.opt.expandtab = false
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 0

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"
vim.opt.foldenable = true
vim.o.foldlevel = 10

local diagconf = {
    virtual_lines_current = { signs = true, virtual_lines = { current_line = true }, virtual_text = false },
    virtual_lines = { signs = false, virtual_lines = { current_line = false }, virtual_text = false },
    virtual_text = {
        signs = false,
        virtual_lines = false,
        virtual_text = {
            format = function(diag)
                -- get only text to first newline
                local message = diag.message:match("[^\n]*")
                if #message < 10 then return diag.source end

                return message
            end,
            source = "if_many",
            prefix = function(diag, i, t)
                if t > 1 and i ~= t then return "" end
                local icons = {
                    [vim.diagnostic.severity.ERROR] = "󰚌 ",
                    [vim.diagnostic.severity.WARN] = "󰯈 ",
                    [vim.diagnostic.severity.INFO] = "󰋼 ",
                    [vim.diagnostic.severity.HINT] = "󰩔 ",
                }
                return icons[diag.severity]
            end,
        },
    },
}

vim.diagnostic.config(diagconf.virtual_text)

vim.keymap.set("n", "<leader>w", function()
    if vim.diagnostic.open_float() == nil then
        local current = vim.diagnostic.config()
        assert(current ~= nil)
        if current.signs and current.virtual_lines then
            vim.diagnostic.config(diagconf.virtual_lines)
        elseif current.virtual_lines then
            vim.diagnostic.config(diagconf.virtual_text)
        else
            vim.diagnostic.config(diagconf.virtual_lines_current)
        end
    end
end, { desc = "Open diagnostic" })
