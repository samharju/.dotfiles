local M = {
    diff_status = {
        added = 0,
        changed = 0,
        removed = 0,
        conflicts = 0,
    },
    per_file = true,
    diff_status_files = {},
    branch = "",
    last_status = "",
    last_file_status = {},
    ticks = {},
}

local function parse_diff_str(status)
    if status == nil then return "" end
    local output = {}
    if status.added > 0 then table.insert(output, string.format("%%#StatusLineAdded#+%s%%*", status.added)) end
    if status.changed > 0 then table.insert(output, string.format("%%#StatusLineChanged#~%s%%*", status.changed)) end
    if status.removed > 0 then table.insert(output, string.format("%%#StatusLineRemoved#-%s%%*", status.removed)) end
    if status.conflicts > 0 then
        table.insert(output, string.format("%%#StatusLineRemoved#!%s%%*", status.conflicts))
    end

    return table.concat(output, " ")
end

function M.update(curbuf)
    if M.branch == "" then M.check_branch() end
    if M.branch == "" then return "", "" end

    local refresh = false

    if curbuf ~= nil then
        local ct = vim.api.nvim_buf_get_changedtick(curbuf)
        if M.ticks[curbuf] ~= ct then
            M.ticks[curbuf] = ct
            refresh = true
        end
        local fname = vim.api.nvim_buf_get_name(curbuf)
        if refresh then
            M.refresh_diff_stats(
                fname,
                function() M.last_file_status[fname] = parse_diff_str(M.diff_status_files[fname]) end
            )
        end

        return M.branch, M.last_file_status[fname]
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) == true then
            local ct = vim.api.nvim_buf_get_changedtick(buf)
            if M.ticks[buf] ~= ct then
                M.ticks[buf] = ct
                refresh = true
                break
            end
        end
    end
    if refresh then M.refresh_diff_stats(nil, function() M.last_status = parse_diff_str(M.diff_status) end) end

    return M.branch, M.last_status
end

function M.check_branch()
    vim.system({ "git", "-C", vim.uv.cwd(), "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }, function(out)
        local b = out.stdout:match("([^\n]+)")
        if b ~= nil then
            M.branch = b
            return
        end
    end)
end

function M.refresh_diff_stats(filename, callback)
    local added = 0
    local changed = 0
    local removed = 0
    local conflicts = 0

    local cmd = { "git", "-C", vim.uv.cwd(), "--no-pager", "diff", "--unified=0" }
    if filename ~= nil then table.insert(cmd, filename) end

    vim.system(cmd, { text = true }, function(out)
        for line in out.stdout:gmatch("[^\n]+") do
            if line:match([[^@@@]]) then
                conflicts = conflicts + 1
            elseif line:match([[^@@]]) then
                local hunk_removed, hunk_added = line:match([[^@@ %-%d+,?(%d*) %+%d+,?(%d*) @@]])

                hunk_added = tonumber(hunk_added)
                if hunk_added == nil then hunk_added = 1 end

                hunk_removed = tonumber(hunk_removed)
                if hunk_removed == nil then hunk_removed = 1 end

                if hunk_removed == 0 and hunk_added > 0 then
                    added = added + hunk_added
                elseif hunk_added == 0 and hunk_removed > 0 then
                    removed = removed + hunk_removed
                else
                    local min = math.min(hunk_removed, hunk_added)

                    changed = changed + min
                    added = added + hunk_added - min
                    removed = removed + hunk_removed - min
                end
            end
        end

        local stats = { added = added, changed = changed, removed = removed, conflicts = conflicts }
        if filename ~= nil then
            M.diff_status_files[filename] = stats
        else
            M.diff_status = stats
        end
        if callback ~= nil then callback() end
    end)
end

return M
