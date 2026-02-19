local cmd = vim.api.nvim_create_user_command
local notify = require("samharju.notify").big

cmd("MergeReviewDiffview", function()
    local c = { "git", "symbolic-ref", "refs/remotes/origin/HEAD" }
    local out = vim.system(c, { text = true }):wait()
    if out.code ~= 0 then return end
    local comp = string.gsub(out.stdout, "\n", "")

    c = {
        "git",
        "merge-base",
        "--fork-point",
        comp,
        "HEAD",
    }

    out = vim.system(c, { text = true }):wait()
    if out.code ~= 0 then return end

    local forkpoint = string.gsub(out.stdout, "\n", "")
    vim.cmd("DiffviewOpen " .. forkpoint)
end, {})

cmd("MergeReviewSigns", function(args)
    notify("Tampering gitsings base for reviewing current branch")
    local comp = args.args

    if comp == "" then
        local c = { "git", "symbolic-ref", "refs/remotes/origin/HEAD" }
        notify(table.concat(c, " "))

        local out = vim.system(c, { text = true }):wait()
        notify(out.stdout)

        if out.code ~= 0 then
            notify(out.stderr, vim.log.levels.ERROR)
            notify("Mergereview: Could not figure remote HEAD", vim.log.levels.ERROR)
        end

        comp = string.gsub(out.stdout, "\n", "")
    end

    local c = {
        "git",
        "merge-base",
        "--fork-point",
        comp,
        "HEAD",
    }

    notify(table.concat(c, " "))
    local out = vim.system(c, { text = true }):wait()
    notify(out.stdout)

    if out.code ~= 0 then
        notify(out.stderr, vim.log.levels.ERROR)
        notify("Could not figure base", vim.log.levels.ERROR)
        return
    end

    local forkpoint = string.gsub(out.stdout, "\n", "")

    require("gitsigns").change_base(forkpoint, true)
    require("gitsigns").toggle_linehl(true)
    require("gitsigns").toggle_word_diff(true)
    notify("Gitsigns base set to " .. forkpoint)

    c = { "git", "diff", comp, "HEAD", "--name-only" }
    notify(table.concat(c, " "))
    out = vim.system(c, { text = true }):wait()
    notify(out.stdout)

    vim.defer_fn(function() require("gitsigns").setqflist("all") end, 1000)
end, { nargs = "?" })

local ns = vim.api.nvim_create_namespace("mergestatus-diag")

cmd("MergeStatus", function(args)
    ---@param out vim.SystemCompleted
    local callback = function(out)
        notify(out.stderr)
        if out.code ~= 0 then return end
        local d = vim.fn.getqflist({
            lines = vim.split(out.stdout, "\n"),
            efm = "%f:%l|%t|%m,%t|%m,%tRROR: %m,%tARNING: %m,%-G\\s%#",
        })
        vim.fn.setqflist(d.items, "r")
        vim.fn.setqflist({}, "a", { title = "MergeStatus" })
        vim.cmd.copen()

        vim.diagnostic.reset(ns)
        local qf = vim.fn.getqflist()

        local diags = setmetatable({}, {
            __index = function(table, key)
                table[key] = {}
                return table[key]
            end,
        })

        for _, item in ipairs(qf) do
            if item.valid == 1 and item.bufnr ~= 0 then
                local diagnostic = {
                    ns = ns,
                    lnum = item.lnum - 1,
                    col = item.col - 1,
                    message = item.text,
                }
                table.insert(diags[item.bufnr], diagnostic)
            end
        end
        for buf, buf_diags in pairs(diags) do
            vim.diagnostic.set(ns, buf, buf_diags)
        end
    end

    local cmdargs = { "gitlab-merge-status" }
    for _, a in ipairs(vim.split(args.args, " ")) do
        if a ~= "" then table.insert(cmdargs, a) end
    end
    notify(table.concat(cmdargs, " "))
    vim.system(cmdargs, {
        text = true,
    }, vim.schedule_wrap(callback))
end, {
    nargs = "?",
    complete = function() return { "--resolved", "--no-merge-comments", "--pipeline", "--debug", "--merged" } end,
})

cmd("MergeConflicts", function(args)
    vim.cmd([[ grep! "<<<<\|>>>>" ]])
    vim.cmd([[copen]])
    vim.cmd([[wincmd p]])
end, {})

cmd("WatchPipeline", function()
    require("samharju.terminal").float_terminal()
    local chan = vim.bo.channel
    vim.api.nvim_chan_send(chan, "watch -t gitlab-pipeline-status\n")
end, {})
