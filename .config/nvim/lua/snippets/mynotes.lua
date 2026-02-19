---@diagnostic disable: undefined-global
return {
    s(
        { trig = "code" },
        fmt(
            [[
            {{code:{}}}
            {{code}}
            ]],
            { i(0) }
        )
    ),
    s(
        { trig = "table" },
        fmt(
            [[
||Heading 1||Heading 2||
|Col A1|Col A2|
        ]],
            {}
        )
    ),
}
