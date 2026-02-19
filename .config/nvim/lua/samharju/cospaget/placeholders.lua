local M = {}

---@param text string
---@return string
function M.replace_placeholders(origin_buf, output_buf, text)
    if text:match("$buffers") ~= nil then
        local content = ""
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local fname = vim.api.nvim_buf_get_name(buf)
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= output_buf and fname ~= "" then
                local c = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
                content = content .. string.format("\n%s\n---\n%s\n---\n\n", vim.fn.fnamemodify(fname, ":."), c)
            end
        end
        text = text:gsub("$buffers", content)
    end

    if text:match("$buffer") ~= nil then
        local contents = table.concat(vim.api.nvim_buf_get_lines(origin_buf, 0, -1, false), "\n")
        local fname = vim.api.nvim_buf_get_name(origin_buf)
        text = text:gsub("$buffer", string.format("\n%s\n---\n%s\n---\n\n", vim.fn.fnamemodify(fname, ":."), contents))
    end

    if text:match("$yank") ~= nil then
        local y = vim.fn.getreg("")
        text = text:gsub("$yank", y)
    end
    if text:match("$function_def") ~= nil then
        local node = vim.treesitter.get_node()
        local sub = ""
        while true do
            if node == nil then break end
            local t = node:type()
            if t == "function_definition" or t == "function_declaration" or t == "method_declaration" then
                sub = vim.treesitter.get_node_text(node, 0)
                break
            end
            node = node:parent()
        end
        text = text:gsub("$function_def", sub)
    end
    if text:match("$filetype") ~= nil then text = text:gsub("$filetype", vim.bo[origin_buf].filetype) end

    if text:match("$diag") ~= nil then
        local d = vim.diagnostic.get_next()
        if d ~= nil then text = text:gsub("$diag", vim.inspect(d)) end
    end

    if text:match("$file:") ~= nil then
        for m in text:gmatch("$file:(%S+)") do
            local file = io.open(m, "r")
            if file ~= nil then
                local contents = file:read("*a")
                text = text:gsub("$file:" .. m, contents)
                file:close()
            else
                text = text:gsub("$file:" .. m, "")
            end
        end
    end

    return text
end

return M
