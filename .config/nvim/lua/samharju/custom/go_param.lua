local ns_id = vim.api.nvim_create_namespace("samharju_go_param")
local group = vim.api.nvim_create_augroup("samharju_go_param", { clear = true })
local hi = require("samharju.custom.hilight_scope_param").highlight_scope_identifiers

local ts = vim.treesitter

local f_query = ts.query.parse(
    "go",
    [[
(method_declaration
  (parameter_list
    (parameter_declaration
      (identifier) @parameter
      )
    )
  (block) @func_body
  )

(function_declaration
  (parameter_list
    (parameter_declaration
      (identifier) @parameter
      )
    )
  (block) @func_body
  )
        ]]
)

local i_q = ts.query.parse(
    "go",
    [[
    (identifier) @id 
    ]]
)

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    pattern = "*.go",
    callback = function() hi(ns_id, f_query, i_q, "go") end,
})
