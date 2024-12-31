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
    black = "#000004",
    dark_grey = "#151530",
    deep_grey = "#101014",
    green = "#40a0a0",
    light_grey = "#aaaaba",
    medium_grey = "#606090",
    purple = "#a0a0df",
    red = "#d0a0a0",
    white = "#dadada",
    yellow = "#fafaaf",
}

hl("CurSearch", { fg = p.purple, reverse = true })
hl("CursorLine", { bg = p.deep_grey })
hl("CursorLineNr", "CursorLine")
hl("FloatBorder", { fg = p.dark_grey })
hl("IncSearch", { bg = p.green })
hl("NonText", { fg = p.dark_grey })
hl("Normal", { fg = p.white, bg = p.black })
hl("NormalFloat", "Normal")
hl("QuickFixLine", { fg = p.purple })
hl("Search", { fg = p.red, reverse = true })
hl("StatusLine", { bg = p.deep_grey })
hl("TabLine", { fg = p.dark_grey })
hl("TabLineSel", { fg = p.purple })
hl("VertSplit", { fg = p.deep_grey })
hl("Visual", { bg = p.dark_grey })
hl("WinBar", { bg = p.deep_grey })
hl("WinBarNC", { fg = p.medium_grey, bg = p.deep_grey })

hl("Pmenu", { fg = p.white })
hl("PmenuSel", "CursorLine")

hl("Comment", { fg = p.medium_grey })

hl("Constant", { fg = p.white })
hl("String", { fg = p.light_grey })

hl("Identifier", { fg = p.white })

hl("Statement", { fg = p.white })
hl("Keyword", { fg = p.purple })

hl("PreProc", { fg = p.green })

hl("Type", { fg = p.red })

hl("Special", { fg = p.purple })

hl("DiagnosticHint", { fg = p.light_grey })

hl("@keyword", "Keyword")
hl("@keyword.conditional", "@keyword")
hl("@keyword.debug", "@keyword")
hl("@keyword.directive", "@keyword")
hl("@keyword.exception", "@keyword")
hl("@keyword.import", "@keyword")
hl("@keyword.repeat", "@keyword")
hl("@keyword.type", "@keyword")
hl("@label.vimdoc", "Keyword")
hl("@lsp.type.parameter", { italic = true })
hl("@markup.link.vimdoc", "Keyword")
hl("@operator", "@keyword")
hl("@tag", "Normal")
hl("@tag.delimiter", "Keyword")
hl("@variable.member", { italic = true })
