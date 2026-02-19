require("samharju.set")
require("samharju.lazy")
require("samharju.maps")
require("samharju.commands")
require("samharju.status")
require("samharju.terminal")
require("samharju.session")
require("samharju.notes")
require("samharju.bufpop")
require("samharju.cospaget")
require("samharju.custom.filetypes")
require("samharju.lsp")

vim.cmd.colorscheme("quitequiet-transparent")

vim.notify = require("samharju.notify").small
