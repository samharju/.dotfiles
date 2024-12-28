vim.cmd("runtime colors/quiet.vim")

vim.o.background = "dark"
vim.g.colors_name = "quitequiet"

local hl = function(group, opts)
    if type(opts) == "string" then
        vim.api.nvim_set_hl(0, group, { link = opts })
        return
    end
    vim.api.nvim_set_hl(0, group, opts)
end

local p = {
    white = "#dadada",
    black = "#000000",
    purple = "#a0a0df",
    yellow = "#fafaaf",
    dark_grey = "#303030",
    medium_grey = "#707070",
    light_grey = "#aaaaaa",
}

hl("CurSearch", { fg = p.purple, reverse = true })
hl("NonText", { fg = p.dark_grey })
hl("Normal", { fg = p.white, bg = p.black })
hl("NormalFloat", "Normal")
hl("QuickFixLine", { fg = p.purple })
hl("Search", { fg = p.yellow, reverse = true })
hl("StatusLine", { bg = p.dark_grey })
hl("TabLine", { fg = p.dark_grey })
hl("TabLineSel", { fg = p.purple })

hl("Constant", { fg = p.white })

hl("Identifier", { fg = p.white })
-- hl("Function", { fg = p.yellow })

hl("Statement", { fg = p.white })

hl("PreProc", { fg = p.white })

hl("Comment", { fg = p.medium_grey })
hl("Keyword", { fg = p.purple })
hl("Special", { fg = p.purple })
hl("String", { fg = p.light_grey })

hl("DiagnosticHint", { fg = p.dark_grey })
hl("DiagnosticInfo", { fg = p.medium_grey })

hl("@keyword", "Keyword")
hl("@keyword.conditional", "@keyword")
hl("@keyword.debug", "@keyword")
hl("@keyword.directive", "@keyword")
hl("@keyword.exception", "@keyword")
hl("@keyword.import", "@keyword")
hl("@keyword.repeat", "@keyword")
hl("@keyword.type", "@keyword")
hl("@operator", "@keyword")
hl("@tag", "Normal")
hl("@tag.delimiter", "Keyword")

hl("@label.vimdoc", "Keyword")
hl("@markup.link.vimdoc", "Keyword")

hl("CmpItemAbbr", "Normal")
hl("CmpItemKind", "Keyword")
hl("CmpItemMenu", "Comment")
hl("CmpItemAbbrMatch", "Special")
hl("CmpItemAbbrMatchFuzzy", "Special")

hl("TelescopeMatching", "Search")
hl("TelescopeSelection", "CursorLine")

hl("fugitiveStagedModifier", "Added")
hl("fugitiveUnstagedModifier", "Removed")
