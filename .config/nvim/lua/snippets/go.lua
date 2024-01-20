---@diagnostic disable: undefined-global
return {

    s(
        { trig = 'ie', name = 'error handling' },
        fmt([[
            if err != nil {{
                {}
            }}
            ]],
            {
                c(1, {
                    t('log.Fatal(err)'),
                    t('return err'),
                    fmt('return fmt.Errorf("{}: %w", err)', { i(1) })
                })
            }
        )
    ),

    s(
        { trig = 'hf', name = 'http handlerfunc' },
        fmt([[
            func {}({} http.ResponseWriter, {} *http.Request) {{
                {}
            }}
            ]],
            { i(1), i(2, 'w'), i(3, 'r'), i(0) })
    ),

    s({ trig = 'jenc', name = 'json to reponsewriter' },
        fmt([[
            {w}.Header().Set("Content-Type", "application/json")
            err := json.NewEncoder({w}).Encode({})
            ]],
            { w = i(1, 'w'), i(0) },
            { repeat_duplicates = true }
        )
    )
}
