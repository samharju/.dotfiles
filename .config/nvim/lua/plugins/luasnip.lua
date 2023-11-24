return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = "make install_jsregexp",
    dependencies = {
        'rafamadriz/friendly-snippets',
    },
    init = function()
        local ls = require('luasnip')

        local isots = function()
            return { os.date('!%Y-%m-%dT%H:%M:%S.000Z') }
        end

        ls.add_snippets(nil, {
            all = {
                ls.snippet({
                        trig = 'isots',
                        namr = 'Iso date',
                        dscr = 'Date in iso8601 format',
                    },
                    {
                        ls.function_node(isots, {})
                    })
            }
        })

        require('luasnip.loaders.from_vscode').lazy_load()
    end


}
