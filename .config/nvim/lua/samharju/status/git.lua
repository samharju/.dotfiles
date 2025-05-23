local M = {
    diff_status = {
        added = 0,
        changed = 0,
        removed = 0,
        conflicts = 0,
    },
    branch = "",
    last_output = "",
    ticks = {},
}

function M.update()
    if M.branch == "" then M.check_branch() end
    if M.branch == "" then return "", "" end

    local refresh = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) == true then
            local ct = vim.api.nvim_buf_get_changedtick(buf)
            if M.ticks[buf] ~= ct then
                M.ticks[buf] = ct
                refresh = true
            end
        end
    end

    if refresh then M.parse_git_diff() end

    local status = M.diff_status

    local output = {}
    if status.added > 0 then table.insert(output, string.format("%%#StatusLineAdded#+%s%%*", status.added)) end
    if status.changed > 0 then table.insert(output, string.format("%%#StatusLineChanged#~%s%%*", status.changed)) end
    if status.removed > 0 then table.insert(output, string.format("%%#StatusLineRemoved#-%s%%*", status.removed)) end
    if status.conflicts > 0 then
        table.insert(output, string.format("%%#StatusLineRemoved#!%s%%*", status.conflicts))
    end

    M.last_output = table.concat(output, " ")
    return M.branch, M.last_output
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

function M.parse_git_diff()
    local added = 0
    local changed = 0
    local removed = 0
    local conflicts = 0

    vim.system({ "git", "-C", vim.uv.cwd(), "--no-pager", "diff", "--unified=0" }, { text = true }, function(out)
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

        M.diff_status = { added = added, changed = changed, removed = removed, conflicts = conflicts }
    end)
end

return M
