vim.cmd.hi("clear")
vim.o.background = "dark"
vim.cmd("runtime colors/quiet.vim")
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
    black_tint = "#000008",
    blue_dark = "#101022",
    blue_deep = "#181833",
    blue_light = "#606090",
    blue = "#3581b8",
    green = "#4ba0a0",
    green_dark = "#002000",
    grey_dark = "#333343",
    grey_light = "#aaaabb",
    purple = "#a0a0df",
    red = "#ef626c",
    red_dark = "#200000",
    white = "#dadada",
    yellow = "#e1e17d",
    orange = "#f7ae62",
}

hl("CurSearch", { fg = p.red, reverse = true })
hl("CursorLine", { bg = p.blue_dark })
hl("CursorLineNr", "CursorLine")
hl("ErrorMsg", { fg = p.red })
hl("FloatBorder", "NormalFloat")
hl("FloatTitle", { fg = p.red, bg = p.black_tint })
hl("IncSearch", { fg = p.purple, reverse = true })
hl("MatchParen", { reverse = true })
hl("NonText", { fg = p.blue_deep })
hl("Normal", { fg = p.white, bg = p.black })
hl("NormalFloat", { bg = p.black_tint })
hl("Pmenu", { fg = p.white })
hl("PmenuSel", "CursorLine")
hl("QuickFixLine", { fg = p.purple })
hl("Search", { fg = p.purple, reverse = true })
hl("StatusLine", { bg = p.blue_dark })
hl("Substitute", { fg = p.red, reverse = true })
hl("TabLine", { fg = p.blue_light })
hl("TabLineSel", { fg = p.red })
hl("TermCursor", { fg = p.white, reverse = true })
hl("Title", { fg = p.red })
hl("VertSplit", { fg = p.blue_dark })
hl("Visual", { bg = p.blue_deep })
hl("WinBar", { bg = p.blue_dark })
hl("WinBarNC", { fg = p.blue_light, bg = p.blue_dark })

hl("Added", { fg = p.green })
hl("Changed", { fg = p.blue })
hl("Removed", { fg = p.red })
hl("DiffAdd", { bg = p.green_dark })
hl("DiffChange", { bg = p.blue_deep })
hl("DiffDelete", { bg = p.red_dark })
hl("DiffText", { bg = p.grey_dark })

hl("Comment", { fg = p.blue_light })

hl("Constant", { fg = p.white })
hl("String", { fg = p.grey_light })
hl("Character", { fg = p.grey_light })

hl("Identifier", { fg = p.white })

hl("Statement", { fg = p.white })
hl("Keyword", { fg = p.purple })

hl("PreProc", { fg = p.purple })

hl("Type", { fg = p.red })

hl("Special", { fg = p.purple })

hl("Todo", { fg = p.green, bg = p.green_dark })
hl("Error", { fg = p.red })

hl("DiagnosticVirtualTextOk", { fg = p.green })
hl("DiagnosticVirtualTextHint", { fg = p.grey_light })
hl("DiagnosticVirtualTextError", { fg = p.red, bg = p.red_dark })
hl("DiagnosticVirtualTextWarn", { fg = p.yellow, bg = p.blue_dark })
hl("DiagnosticVirtualTextInfo", { fg = p.blue_light })

hl("DiagnosticOk", { fg = p.green })
hl("DiagnosticHint", { fg = p.grey_light })
hl("DiagnosticError", { fg = p.red })
hl("DiagnosticWarn", { fg = p.yellow })
hl("DiagnosticInfo", { fg = p.blue_light })

hl("DiagnosticUnderlineOk", { undercurl = true, sp = p.green })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.grey_light })
hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue_light })

hl("@keyword", "Keyword")
hl("@keyword.conditional", "@keyword")
hl("@keyword.debug", "@keyword")
hl("@keyword.directive", "@keyword")
hl("@keyword.exception", "@keyword")
hl("@keyword.import", "@keyword")
hl("@keyword.repeat", "@keyword")
hl("@keyword.type", "@keyword")
hl("@label.vimdoc", "Keyword")
hl("@markup.link.vimdoc", "Keyword")
hl("@operator", "@keyword")
hl("@string.documentation", "Comment")
hl("@tag", "Normal")
hl("@tag.delimiter", "Keyword")
hl("@variable.parameter", { fg = p.orange })

hl("@lsp.type.parameter", "@variable.parameter")

hl("NvimTreeGitDirtyIcon", "Changed")
