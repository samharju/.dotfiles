return {
    {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        config = function()
            local cmp = require("cmp")
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer", keyword_length = 3 },
                },
            })

            cmp.setup.cmdline("?", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer", keyword_length = 3 },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path", option = { get_cwd = function(_) return vim.fn.getcwd() end } },
                    { name = "cmdline" },
                }),
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        version = false,
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local ls = require("luasnip")
            cmp.setup({
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            buffer = "[Buffer]",
                            nvim_lua = "[Lua]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args) ls.lsp_expand(args.body) end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path", option = { get_cwd = vim.loop.cwd } },
                    {
                        name = "buffer",
                        option = {
                            get_bufnrs = function()
                                -- source from visible buffers
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                local res = vim.api.nvim_exec2(":ls", { output = true })
                                if res ~= nil and res.output ~= nil then
                                    local _, _, alt = string.find(res.output, "%s+(%d+)%s+#")
                                    if alt ~= nil then bufs[tonumber(alt)] = true end
                                end
                                return vim.tbl_keys(bufs)
                            end,
                        },
                        keyword_length = 3,
                    },
                },
                sorting = {
                    comparators = {
                        function(entry1, entry2) return require("cmp_buffer"):compare_locality(entry1, entry2) end,
                        require("cmp.config.compare").offset,
                        require("cmp.config.compare").exact,
                        -- require"cmp.config.compare".scopes,
                        require("cmp.config.compare").score,
                        require("cmp.config.compare").recently_used,
                        require("cmp.config.compare").locality,
                        require("cmp.config.compare").kind,
                        -- require"cmp.config.compare".sort_text,
                        require("cmp.config.compare").length,
                        require("cmp.config.compare").order,
                    },
                },
                mapping = {
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if ls.locally_jumpable(1) then
                            ls.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function(fallback)
                        if ls.locally_jumpable(-1) then
                            ls.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if #cmp.get_entries() == 1 then
                                cmp.confirm({ select = true })
                            else
                                cmp.select_next_item()
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-e>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end, { "i", "s" }),
                },
            })
        end,
    },
}
