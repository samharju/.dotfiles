---@diagnostic disable: undefined-global
return {
    s("shebang", {
        c(1, {
            t({ "#!/usr/bin/env bash", "" }),
            t({ "#!/bin/bash", "" }),
            t({ "#!/usr/bin/env python3", "" }),
        }),
    }),

    s({
        trig = "isots",
        name = "Iso date",
        dscr = "timestamp in sane format",
    }, {
        f(function() return { os.date("!%Y-%m-%dT%H:%M:%S.000Z") } end, {}),
    }),
}
