local M = {
    diff_status = {
        added = 0,
        changed = 0,
        removed = 0,
        conflicts = 0,
    },
    branch = "",
}

function M.setup(group)
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        group = group,
        callback = function()
            local stl_default = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
            local hl_added = vim.api.nvim_get_hl(0, { name = "Added", link = false })
            local hl_changed = vim.api.nvim_get_hl(0, { name = "Changed", link = false })
            local hl_removed = vim.api.nvim_get_hl(0, { name = "Removed", link = false })

            vim.api.nvim_set_hl(
                0,
                "StatusLineAdded",
                { fg = hl_added.fg, bg = stl_default.bg, reverse = stl_default.reverse }
            )
            vim.api.nvim_set_hl(
                0,
                "StatusLineChanged",
                { fg = hl_changed.fg, bg = stl_default.bg, reverse = stl_default.reverse }
            )
            vim.api.nvim_set_hl(
                0,
                "StatusLineRemoved",
                { fg = hl_removed.fg, bg = stl_default.bg, reverse = stl_default.reverse }
            )
        end,
    })
end

function M.update()
    M.check_branch()
    if M.branch == "" then return "" end

    local branch = M.branch .. ""

    M.parse_git_diff()

    local status = M.diff_status

    local output = { branch }
    if status.added > 0 then table.insert(output, string.format("%%#StatusLineAdded#+%s%%*", status.added)) end
    if status.changed > 0 then table.insert(output, string.format("%%#StatusLineChanged#~%s%%*", status.changed)) end
    if status.removed > 0 then table.insert(output, string.format("%%#StatusLineRemoved#-%s%%*", status.removed)) end
    if status.conflicts > 0 then table.insert(output, string.format("%%#User3#!%s%%*", status.conflicts)) end

    return table.concat(output, " ")
end

function M.check_branch()
    vim.system(
        { "git", "-C", vim.loop.cwd(), "rev-parse", "--abbrev-ref", "HEAD" },
        { text = true },
        function(out) M.branch = out.stdout:match("([^\n]+)") end
    )
end

function M.parse_git_diff()
    local added = 0
    local changed = 0
    local removed = 0
    local conflicts = 0

    vim.system({ "git", "-C", vim.loop.cwd(), "--no-pager", "diff", "--unified=0" }, { text = true }, function(out)
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
