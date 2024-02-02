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
                    fmt('return fmt.Errorf("{}: %w", err)', { i(1) }),
                    fmt([[
                        log.Printf("{}: %s", err)
                        return err
                        ]],
                        { i(1) }),
                    t('log.Fatal(err)'),
                    t('return err'),
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
    ),

    s({ trig = 'httpreq', name = 'http request' },
        fmta([[
            req, err := http.NewRequestWithContext(
                context.Background(),
                <method>,
                <url>,
                <body>,
                )
            if err != nil {
                <errhandle>
            }
            res, err := http.<client>.Do(req)
            if err != nil {
                <errhandle>
            }
            defer res.Body.Close()
            b, err := io.ReadAll(res.Body)
            if err != nil {
                <errhandle>
            }
            fmt.Printf("%s\n", b)
            ]],
            {
                method = c(1, {
                    t('http.MethodGet'),
                    t('http.MethodPost'),
                    t('http.MethodPut'),
                    t('http.MethodDelete'),
                }),
                url = i(2, 'url'),
                body = c(3, {
                    t('nil'),
                    t('body')
                }),
                client = c(4, {
                    t('client'),
                    t('DefaultClient')
                }),
                errhandle = c(5, {
                    t('log.Fatal(err)'),
                    t('return err'),
                })
            },
            { repeat_duplicates = true }
        )
    )

}
