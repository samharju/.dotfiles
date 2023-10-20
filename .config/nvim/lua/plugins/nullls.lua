return {
    'jose-elias-alvarez/null-ls.nvim',
    init = function()
        local null_ls = require('null-ls')

        local function bootstrap()
            -- only attach sources that are available
            local sources = {
                {
                    source = null_ls.builtins.formatting.black,
                    bin = 'black'
                },
                {
                    source = null_ls.builtins.diagnostics.flake8,
                    bin = 'flake8'
                },
                {
                    source = null_ls.builtins.formatting.goimports,
                    bin = 'goimports'
                },
                {
                    source = null_ls.builtins.formatting.prettier,
                    bin = 'prettier'
                },
                {
                    source = null_ls.builtins.formatting.isort,
                    bin = 'isort'
                },
                {
                    source = null_ls.builtins.diagnostics.mypy,
                    bin = 'mypy'
                },
            }

            M = {}
            for _, v in ipairs(sources) do
                if vim.fn.executable(v.bin) == 1 then
                    table.insert(M, v.source)
                end
            end
            return M
        end

        null_ls.setup({
            sources = bootstrap()
        })
    end

}
