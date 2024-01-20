---@diagnostic disable: undefined-global
return {
    s('main', t({ 'if __name__ == "__main__":', '\t' })),
    s('pprint', fmt('__import__("pprint").pprint({})', { i(1) }))
}
