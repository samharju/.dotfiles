---@diagnostic disable: undefined-global
return {
    s({ trig = "lc", snippetType = "autosnippet" }, fmt("[{} for {} in {}]", { i(1), i(2), i(3) })),
    s(
        { trig = "with o", snippetType = "autosnippet" },
        fmt(
            [[
              with open("{}"{}) as f:
                  {}
            ]],
            {
                i(1),
                c(2, {
                    t(', "w"'),
                    t(""),
                }),
                i(3),
            }
        )
    ),
    s({ trig = "main", name = "main" }, t({ 'if __name__ == "__main__":', "\t" })),
    s({ trig = "pprint" }, fmt('__import__("pprint").pprint({})', { i(1) })),
    s({ trig = "bpp", snippetType = "autosnippet" }, t("breakpoint()")),
    s(
        { trig = "deflog", snippetType = "autosnippet" },
        t({
            "import logging",
            "",
            "logging.basicConfig(",
            "\tlevel=logging.INFO,",
            '\tformat="%(name)s:%(filename)s:%(lineno)s [%(levelname)s]: %(message)s"',
            ")",
            "",
            "logger = logging.getLogger(__name__)",
        })
    ),
    s({ trig = "li", name = "log info" }, fmt("logger.info({})", { i(1) })),
    s({ trig = "ld", name = "log debug" }, fmt("logger.debug({})", { i(1) })),
    s({ trig = "le", name = "log error" }, fmt("logger.error({})", { i(1) })),
    s({ trig = "lw", name = "log warning" }, fmt("logger.warning({})", { i(1) })),

    --es stuff
    s(
        { trig = "esfilter", snippetType = "autosnippet" },
        fmta(
            [[
            {
              "query": {
                "bool": {
                  "filter": [
                    <>
                  ]
                }
              }
            }
            ]],
            {
                i(0),
            }
        )
    ),
    s(
        { trig = "esquery", snippetType = "autosnippet" },
        fmta(
            [[
            {
              "query": {
                "bool": {
                  "filter": [
                    <>
                  ]
                }
              },
              "aggs": {
                "<>": {
                  "terms": {
                    "field": "<>",
                    "size": 10
                  }
                }
              },
              "sort": [ "<>" ],
              "_source": [ "<>" ],
              "size": 10
            }
            ]],
            {
                i(1),
                i(2),
                i(3),
                i(4),
                i(5),
            }
        )
    ),
    s(
        { trig = "esagg", snippetType = "autosnippet" },
        c(1, {
            fmta(
                [["aggs": {"<a>": {"terms": {"field": "<a>", "size": 10}}}]],
                { a = i(1) },
                { repeat_duplicates = true }
            ),
            fmta(
                [[ 
                "aggs": {
                  "<>": {
                    "composite": {
                      "sources": [
                        {"<>": {"terms": {"field": "<>" }}
                        }
                      ],
                      "size": 1000
                    }
                  }
                }
                ]],
                { i(1), i(2), i(3) }
            ),
        })
    ),
    s(
        { trig = "esterm", snippetType = "autosnippet" },
        c(1, {
            fmta([[{"term": {"<>": <>}}]], { i(1), i(2) }),
            fmta([[{"terms": {"<>": <>}}]], { i(1), i(2) }),
            fmta([[{"range": {"<>": {"gte": <>}}}]], { i(1), i(2) }),
            fmta([[{"exists": {"field": "<>"}}]], { i(1) }),
        })
    ),
}
