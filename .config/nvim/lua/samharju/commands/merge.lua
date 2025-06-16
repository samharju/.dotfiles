local cmd = vim.api.nvim_create_user_command

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
    vim.print("Tampering gitsings base for reviewing current branch")
    local comp = args.args

    if comp == "" then
        local c = { "git", "symbolic-ref", "refs/remotes/origin/HEAD" }
        vim.print(table.concat(c, " "))

        local out = vim.system(c, { text = true }):wait()
        vim.print(out.stdout)

        if out.code ~= 0 then
            vim.print(out.stderr, vim.log.levels.ERROR)
            vim.print("Mergereview: Could not figure remote HEAD", vim.log.levels.ERROR)
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

    vim.print(table.concat(c, " "))
    local out = vim.system(c, { text = true }):wait()
    vim.print(out.stdout)

    if out.code ~= 0 then
        vim.print(out.stderr, vim.log.levels.ERROR)
        vim.print("Could not figure base", vim.log.levels.ERROR)
        return
    end

    local forkpoint = string.gsub(out.stdout, "\n", "")

    require("gitsigns").change_base(forkpoint, true)
    require("gitsigns").toggle_linehl(true)
    require("gitsigns").toggle_word_diff(true)
    vim.print("Gitsigns base set to " .. forkpoint)

    c = { "git", "diff", comp, "HEAD", "--name-only" }
    vim.print(table.concat(c, " "))
    out = vim.system(c, { text = true }):wait()
    vim.print(out.stdout)

    for _, fname in ipairs(vim.split(out.stdout, "\n")) do
        if fname ~= "" then vim.cmd.e(fname) end
    end

    vim.defer_fn(function() require("gitsigns").setqflist("attached") end, 2000)
end, { nargs = "?" })

cmd("MergeStatus", function(args)
    local cmdargs = { "gitlab-merge-stuff" }
    for _, a in ipairs(vim.split(args.args, " ")) do
        if a ~= "" then table.insert(cmdargs, a) end
    end
    local callback = function(out)
        vim.print(out.stderr)
        local d = vim.fn.getqflist({
            lines = vim.split(out.stdout, "\n"),
            efm = "%f:%l|%t|%m,%t|%m,%tRROR: %m,%tARNING: %m,%-G\\s%#",
        })
        vim.fn.setqflist(d.items, "r")
        vim.fn.setqflist({}, "a", { title = "MergeStatus" })
        vim.cmd.copen()
    end

    vim.system(cmdargs, {
        text = true,
    }, vim.schedule_wrap(callback))
end, {
    nargs = "?",
    complete = function() return { "--resolved", "--no-merge-comments", "--pipeline", "--debug", "--merged" } end,
})

cmd("MergeConflicts", function(args)
    vim.cmd([[ grep! "<<<<<<<\|>>>>>>>" ]])
    vim.cmd([[copen]])
    vim.cmd([[wincmd p]])
end, {})
