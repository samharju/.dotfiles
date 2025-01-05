local ns_id = vim.api.nvim_create_namespace("samharju_python_param_q")
local group = vim.api.nvim_create_augroup("samharju_python_param_q", { clear = true })

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
-- Function to highlight matching identifiers in the current scope
local function highlight_scope_identifiers()
    local bufnr = vim.api.nvim_get_current_buf()
    local tree = ts.get_parser(bufnr, "python"):parse()[1]

    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    local params = {}
    local scope = nil

    for id, fnode in f_query:iter_captures(tree:root(), bufnr) do
        local capture_name = f_query.captures[id]
        if capture_name == "func_body" then
            scope = fnode
        elseif capture_name == "parameter" then
            table.insert(params, ts.get_node_text(fnode, bufnr))
        end

        if scope ~= nil then
            for _, i_node in i_q:iter_captures(scope, bufnr) do
                local var_name = ts.get_node_text(i_node, bufnr)

                if vim.tbl_contains(params, var_name) then
                    local start_row, start_col, _, end_col = i_node:range()

                    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "@variable.parameter", start_row, start_col, end_col)
                end
            end
            scope = nil
            params = {}
        end
    end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    pattern = "*.py",
    callback = function() highlight_scope_identifiers() end,
})
