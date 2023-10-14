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

    -----------------------------------------
    -- visual stuff

    use 'navarasu/onedark.nvim'

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use 'nvim-treesitter/nvim-treesitter-context'
    use { 'lukas-reineke/indent-blankline.nvim', tag="v2.*"}
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    use 'folke/zen-mode.nvim'
    use 'NvChad/nvim-colorizer.lua'
    ------------------------------------------
    -- movement

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use 'theprimeagen/harpoon'
    use 'mbbill/undotree'
    use { 'akinsho/toggleterm.nvim', tag = '*' }
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use 'folke/flash.nvim'

    --------------------------------------------
    -- git

    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'


    --------------------------------------------
    -- lsp and cmp

    use {
        'williamboman/mason.nvim',
        run = function() pcall(vim.cmd, 'MasonUpdate') end
    }
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'

    --completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'folke/neodev.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'ray-x/lsp_signature.nvim'

    -- snippets
    use {
        'L3MON4D3/LuaSnip',
        -- follow latest release.
        tag = 'v1.*',
        after = 'nvim-cmp',
    }
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'

    -- other than lsp formatting and diags
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'terrortylor/nvim-comment'

    use 'windwp/nvim-ts-autotag'

    use 'mzlogin/vim-markdown-toc'
    --goofy stuff
    use 'eandrju/cellular-automaton.nvim'

    -- setup packer automatically
    if packer_bootstrap then
        require('packer').sync()
    end
end)
