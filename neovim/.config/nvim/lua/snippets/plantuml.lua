---@diagnostic disable: undefined-global
return {
    s(
        "@startuml",
        fmt(
            [[
        @startuml
        {}

        @enduml
        ]],
            {
                i(0),
            }
        )
    ),
    s(
        { trig = "acti", snippetType = "autosnippet" },
        fmt("activate {a}\ndeactivate {a}", { a = i(1) }, { repeat_duplicates = true })
    ),
    s(
        { trig = "alt", snippetType = "autosnippet" },
        fmt(
            [[
            alt {}
            else
            end
            ]],
            { i(0) }
        )
    ),
}
