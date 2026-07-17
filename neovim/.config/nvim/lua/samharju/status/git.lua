local M = {
    commit_status = {
        ahead = 0,
        behind = 0,
    },
    branch = "",
    status = "",
    last_commit = "",
    ticks = {},
}

function M.format_diff_str(status)
    if not status then return "" end
    local output = {}
    if status.added and status.added > 0 then
        table.insert(output, string.format("%%#StatusLineAdded#+%s%%*", status.added))
    end
    if status.changed and status.changed > 0 then
        table.insert(output, string.format("%%#StatusLineChanged#~%s%%*", status.changed))
    end
    if status.removed and status.removed > 0 then
        table.insert(output, string.format("%%#StatusLineRemoved#-%s%%*", status.removed))
    end
    if status.conflicts and status.conflicts > 0 then
        table.insert(output, string.format("%%#StatusLineRemoved#!%s%%*", status.conflicts))
    end

    return table.concat(output, " ")
end

function M.update()
    local refresh = false
    local b = vim.b.gitsigns_head or M.branch

    if M.commit_status.behind > 0 then
        b = b .. string.format("%%#StatusLineComment# %s󱞣%%s", M.commit_status.behind)
    end
    if M.commit_status.ahead > 0 then
        b = b .. string.format("%%#StatusLineComment# %s󱞿%%s", M.commit_status.ahead)
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
    if refresh then
        M.refresh_status()
        M.refresh_upstream_status()
        M.refresh_head_commit()
    end

    return b, M.status
end

function M.refresh_status()
    local added = 0
    local changed = 0
    local removed = 0
    local conflicts = 0

    local cmd = { "git", "-C", vim.uv.cwd(), "--no-pager", "diff", "--unified=0" }

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

        M.status = M.format_diff_str({ added = added, changed = changed, removed = removed, conflicts = conflicts })
    end)
end

function M.refresh_upstream_status()
    local cmd = { "git", "-C", vim.uv.cwd(), "status", "-sb", "--porcelain=v1" }
    vim.system(cmd, { text = true }, function(out)
        local ahead = out.stdout:match("ahead (%d+)")
        if ahead ~= nil then
            M.commit_status.ahead = tonumber(ahead)
        else
            M.commit_status.ahead = 0
        end

        local behind = out.stdout:match("behind (%d+)")
        if behind ~= nil then
            M.commit_status.behind = tonumber(behind)
        else
            M.commit_status.behind = 0
        end
    end)
end

function M.refresh_head_commit()
    local cmd = { "git", "-C", vim.uv.cwd(), "log", "-1", "--format=%h %s" }
    vim.system(cmd, { text = true }, function(out)
        local sha, title = out.stdout:match("^(%w+) (.*)\n")
        if sha then M.last_commit = string.format("%%#StatusLineWarn#%s%%* %s", sha, title) end
    end)
end

vim.system({ "git", "-C", vim.uv.cwd(), "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }, function(out)
    local b = out.stdout:match("([^\n]+)")
    if b ~= nil then
        M.branch = b
        return
    end
end)

return M
