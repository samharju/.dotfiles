return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },
        { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    },
    event = "VeryLazy",
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                -- Replace these with whatever servers you want to install
                "bashls",
                "docker_compose_language_service",
                "dockerls",
                "gopls",
                "lua_ls",
                "basedpyright",
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "tree-sitter-cli",
                "prettierd",
                "stylua",
            },
        })

        require("mason-lspconfig").setup_handlers({
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup({})
            end,
            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            format = {
                                enable = false,
                            },
                        },
                    },
                })
            end,
            ["bashls"] = function()
                require("lspconfig").bashls.setup({
                    filetypes = { "sh", "zsh" },
                })
            end,
            ["basedpyright"] = function()
                require("lspconfig").basedpyright.setup({
                    settings = {
                        basedpyright = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                typeCheckingMode = "basic",
                                useLibraryCodeForTypes = true,
                                ignore = { "venv" },
                                diagnosticSeverityOverrides = {
                                    reportOptionalMemberAccess = "information",
                                    reportAttributeAccessIssue = "information",
                                    reportCallIssue = "information",
                                },
                            },
                        },
                    },
                })
            end,
        })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            -- Use a sharp border with `FloatBorder` highlights
            border = "single",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            -- Use a sharp border with `FloatBorder` highlights
            border = "single",
        })
    end,
}
