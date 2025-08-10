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

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        for _, ls in ipairs({
            "gopls",
            "docker_compose_language_service",
            "dockerls",
            "ansiblels",
            "bashls",
            "ts_ls",
        }) do
            lspconfig[ls].setup({ capabilities = capabilities })
        end

        lspconfig.basedpyright.setup({
            capabilities = capabilities,
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
            capabilities = capabilities,
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
}
