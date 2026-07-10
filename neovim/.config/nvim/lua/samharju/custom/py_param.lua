local ns_id = vim.api.nvim_create_namespace("samharju_python_param")
local group = vim.api.nvim_create_augroup("samharju_python_param", { clear = true })
local hi = require("samharju.custom.hilight_scope_param").highlight_scope_identifiers

local ts = vim.treesitter

local f_query = ts.query.parse(
    "python",
    [[
        (function_definition
            [
            (parameters
                [
                (identifier) @parameter
                (typed_parameter) @parameter
                ]
            )
            (block) @func_body
            ]
        )
        ]]
)

local i_q = ts.query.parse(
    "python",
    [[
    (identifier) @id 
    ]]
)

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    pattern = "*.py",
    callback = function() hi(ns_id, f_query, i_q, "python") end,
})
