return {
    'nvimtools/none-ls.nvim',
    init = function()
        local null_ls = require('null-ls')

        -- only attach sources that are available
        local builtins = {
            { source = null_ls.builtins.code_actions.gomodifytags, bin = 'gomodifytags' },
            { source = null_ls.builtins.code_actions.impl,         bin = 'impl' },
            { source = null_ls.builtins.diagnostics.flake8,        bin = 'flake8' },
            { source = null_ls.builtins.diagnostics.mypy,          bin = 'mypy' },
            { source = null_ls.builtins.formatting.black,          bin = 'black' },
            { source = null_ls.builtins.formatting.gofmt,          bin = 'gofmt' },
            { source = null_ls.builtins.formatting.goimports,      bin = 'goimports' },
            { source = null_ls.builtins.formatting.golines,        bin = 'golines' },
            { source = null_ls.builtins.formatting.isort,          bin = 'isort' },
            { source = null_ls.builtins.formatting.prettier,       bin = 'prettier' },
        }

        local sources = {}
        for _, v in ipairs(builtins) do
            if vim.fn.executable(v.bin) == 1 then
                table.insert(sources, v.source)
            end
        end

        null_ls.setup({
            sources = sources,
        })
    end,
}
