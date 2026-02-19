return {
    "saghen/blink.cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
    },
    event = "VeryLazy",
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<Tab>"] = { "select_next", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-l>"] = { "snippet_forward", "fallback" },
            ["<C-h>"] = { "snippet_backward", "fallback" },
            ["<C-e>"] = { "cancel", "fallback" },
        },
        snippets = { preset = "luasnip" },
        completion = {
            documentation = {
                window = { border = "rounded" },
                auto_show = true,
            },
            menu = {
                border = "rounded",
                auto_show = true,
                draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } } },
            },
            list = { selection = { preselect = false, auto_insert = true } },
        },
        signature = { window = { border = "rounded" } },
        sources = {
            default = { "lsp", "buffer", "snippets", "path" },
            min_keyword_length = 0,
            per_filetype = {
                lua = { inherit_defaults = true, "lazydev" },
            },
            providers = {
                snippets = {
                    score_offset = 3,
                },
                lsp = {
                    score_offset = 2,
                },
                path = {
                    score_offset = 1,
                },
                buffer = {
                    score_offset = 0,
                    min_keyword_length = 3,
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        cmdline = {
            enabled = true,
            completion = {
                menu = { auto_show = true },
                list = { selection = { preselect = false, auto_insert = true } },
            },
            keymap = { preset = "inherit", ["<CR>"] = { "accept_and_enter", "fallback" } },
        },
    },
    opts_extend = { "sources.default" },
}
