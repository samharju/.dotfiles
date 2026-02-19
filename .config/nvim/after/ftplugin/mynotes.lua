if vim.b.did_custom_ftplugin then
    return
end
vim.b.did_custom_ftplugin = 1

vim.fn.matchadd("DiagnosticOk", [[\v.*<OK>.*]], 100)
vim.fn.matchadd("DiagnosticError", [[\v.*<NOK>.*]], 100)

local cmd = vim.api.nvim_create_user_command

cmd("JiraFromFormat", function()
    local content = vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})
    local output = {}
    for _, l in ipairs(content) do
        if string.match(l, "^*.*") then
            table.insert(output, "### " .. l)
        else
            l = string.gsub(l, "^%s", "")
            local m = string.match(l, "^(%*+%s)")
            if m then
                local count = #m - 1
                local repl = string.rep("  ", count) .. "* "
                local pattern = string.gsub(m, "%*", "%%*")
                local o = string.gsub(l, pattern, repl, 1)
                table.insert(output, o)
            else
                m = string.match(l, "^-%a")
                if m then
                    local o = string.gsub(l, "^-", "- ", 1)

                    table.insert(output, o)
                else
                    table.insert(output, l)
                end
            end
        end
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end, {})

cmd("JiraToFormat", function()
    local content = vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})
    local output = {}
    for _, l in ipairs(content) do
        local m = string.match(l, "^### ")
        if m then
            table.insert(output, string.sub(l, 5))
        else
            m = string.match(l, "^(%s+%*)")
            if m then
                local repl = string.rep("*", (#m / 2 - 1))
                local pattern = string.gsub(m, "%-", "%%-")
                local o = string.gsub(l, pattern, repl, 1)
                table.insert(output, o)
            else
                table.insert(output, l)
            end
        end
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end, {})

cmd("JiraGetDesc", function()
    local key = string.match(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~"), "FCA_RSP%-%d+")

    vim.system({ "jirahero", "get", key }, { text = true }, function(out)
        vim.schedule(function()
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(out.stdout, "\n"))
            vim.cmd.vsplit()
            vim.api.nvim_set_current_buf(buf)
            vim.bo[buf].filetype = "markdown"
            vim.cmd([[JiraFromFormat]])
        end)
    end)
end, {})

cmd("JiraUpdateDesc", function()
    local fullname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
    local fname = vim.fn.fnamemodify(fullname, ":t")
    local key = nil
    for v in string.gmatch(fname, "FCA_RSP%-%d+") do
        if v then key = v end
    end
    if not key then
        vim.notify("Could not find ticket key from filename")
        return
    end

    vim.system({ "jirahero", "update_description", key, fullname }, { text = true }, function(out)
        vim.schedule(function()
            if out.stderr then vim.print(out.stderr) end
            if out.stdout then vim.print(out.stdout) end
        end)
    end)
end, {})
