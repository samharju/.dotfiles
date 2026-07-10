---@diagnostic disable: undefined-global
return {

    s({ trig = "wip", snippetType = "autosnippet" }, t("--wip--")),
    s({
        trig = "cc",
        name = "conventional commit",
        snippetType = "autosnippet",
    }, {
        c(1, {
            t("build"),
            t("chore"),
            t("ci"),
            t("docs"),
            t("feat"),
            t("fix"),
            t("perf"),
            t("refactor"),
            t("revert"),
            t("style"),
            t("test"),
        }),
        i(2, "(scope)"),
        t(": "),
        i(3, "summary"),
        t({ "", "", "" }),
        i(4, "body"),
    }),
}
