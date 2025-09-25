vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

vim.lsp.enable({
    "lua_ls",
    "basedpyright",
    "gopls",
    "docker_compose_language_service",
    "dockerls",
    "ansiblels",
    "bashls",
    "ts_ls",
})
