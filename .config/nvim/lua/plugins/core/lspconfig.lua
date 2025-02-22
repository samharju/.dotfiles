return {
    "neovim/nvim-lspconfig",
    dependencies = {
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
        local lspconfig = require("lspconfig")

        for _, ls in ipairs({
            "gopls",
            "docker_compose_language_service",
            "dockerls",
            "ansiblels",
            "bashls",
        }) do
            lspconfig[ls].setup({})
        end

        lspconfig.basedpyright.setup({
            on_init = function(client, _) client.server_capabilities.semanticTokensProvider = nil end,
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
                            reportOperatorIssue = "information",
                        },
                    },
                },
            },
        })

        lspconfig.lua_ls.setup({
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

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            -- Use a sharp border with `FloatBorder` highlights
            border = "rounded",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            -- Use a sharp border with `FloatBorder` highlights
            border = "rounded",
        })
    end,
}
