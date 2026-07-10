local ts = vim.treesitter

local M = {}

M.highlight_scope_identifiers = function(ns_id, scope_q, identifier_q, lang)
    local bufnr = vim.api.nvim_get_current_buf()
    local tree = ts.get_parser(bufnr, lang):parse()[1]

    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    local params = {}
    local scope = nil

    for id, fnode in scope_q:iter_captures(tree:root(), bufnr) do
        local capture_name = scope_q.captures[id]
        if capture_name == "func_body" then
            scope = fnode
        elseif capture_name == "parameter" then
            table.insert(params, ts.get_node_text(fnode, bufnr))
        end

        if scope ~= nil then
            for _, i_node in identifier_q:iter_captures(scope, bufnr) do
                local var_name = ts.get_node_text(i_node, bufnr)

                if vim.tbl_contains(params, var_name) then
                    local start_row, start_col, _, end_col = i_node:range()

                    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "@lsp.type.parameter", start_row, start_col, end_col)
                end
            end
            scope = nil
            params = {}
        end
    end
end

return M
