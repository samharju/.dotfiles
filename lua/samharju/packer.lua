local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()


return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    --theme stuff
    use({ 'rose-pine/neovim', as = 'rose-pine' })
    use "lunarvim/synthwave84.nvim"
    --visuals
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    --movement
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    --highlight
    use 'nvim-tree/nvim-tree.lua'

    use 'nvim-tree/nvim-web-devicons'

    --git
    use('tpope/vim-fugitive')
    use('airblade/vim-gitgutter')


    --lsp
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"

    --lsp utils
    use "jose-elias-alvarez/null-ls.nvim"

    --completion
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use 'hrsh7th/nvim-cmp'
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "windwp/nvim-ts-autotag"

    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v1.*",
    })

    if packer_bootstrap then
        require('packer').sync()
    end
end)
