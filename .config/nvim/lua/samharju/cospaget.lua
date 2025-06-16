local M = {}

local logfile = vim.fn.stdpath("cache") .. "/cospaget.log"

local function log(...)
    local w = io.open(logfile, "a")
    if w == nil then
        vim.notify_once("dotfile logging failed", vim.log.levels.ERROR)
        return
    end

    local args = { ... }
    for index, value in ipairs(args) do
        if type(value) == "table" then
            args[index] = vim.inspect(value)
        else
            args[index] = tostring(value)
        end
    end

    local msg = table.concat(args, " ")

    local s = debug.getinfo(2, "Sl")
    local file = s.source:match("lua/(.*.lua)$")
    local line = s.currentline

    w:write(string.format("[%s] %s:%s: %s\n", os.date(), file, line, msg))
    w:close()
end

local function preprompt(filetype, hints)
    local pretext = {
        "I need you to give me a oneline comment, something similar to these examples.",
        "Comment should be somehow relevant to language: " .. filetype .. ".",
        "Apart from these examples, you can also throw punches about variable or function naming etc.",
        "Output only the response text.",
        "Keep it nasty.",
    }

    if hints ~= nil then
        for _, line in ipairs(hints) do
            table.insert(pretext, line)
        end
    end

    local suffix = {
        "Examples:",
        "-----",
        "The error message is the computer's way of telling you it's disappointed in your code.",
        "Have you tried guessing what the problem is and fix it?",
        "Wave your hands and say 'abracadabra' and it should work.",
        "Throw in some random characters and see what happens.",
        "I would go with debugging line by line but ain't nobody got time for that.",
        "Keep adding more features, eventually something overlaps enough and you can remove all of this code.",
        "Google it, you'll find something that works.",
        "Keep pinging it until it responds.",
        "We don't need that line, failing assertions are good to go in production.",
        "Roll back to a previous version and pray that you backed up your code.",
        "Did you even bother googling this?",
        "Have you considered asking a psychic for help?",
        "Nah, add more nested if statements and hope for the best.",
        "I prefer to use the Force to debug my code.",
        "Manually test everything and call it a day.",
        "Throw some spaghetti at the wall and see what sticks.",
        "Go ahead, keep trying the same thing over and over again.",
        "Sometimes refactoring the code fixes that, but ain't nobody got time for that.",
        "3rd party stuff, hope that they magically fix themselves.",
        "Go on to Reddit and hope for the best.",
        "Would different programming language or framework help?",
        "Comment out that test and see if anything sticks in production.",
        "Commit, push and wish the on-call good luck.",
        "Real devs enjoy the surprise of silent breaking changes.",
        "Sure, who needs performance anyway.",
        "Clearly the framework should adapt to *your* code.",
        "If users can’t wait, they will definitely learn it with this implementation.",
        "That’s called a feature, not a bug.",
        "Delete it; dependency roulette is thrilling.",
        "That line looks like a perfect sunday night on-call ticket.",
        "Real code loves living dangerously.",
        "Why not print the entire universe while you're at it.",
        "Seems like your software has character.",
        "Change the specification to match the implementation!",
        "Secrets are overrated; hard-code them.",
    }

    for _, line in ipairs(suffix) do
        table.insert(pretext, line)
    end
    return pretext
end

local function open_prompt(response, row)
    local buf = vim.api.nvim_create_buf(false, true)
    response = vim.split(response, "\n")
    -- local h = #response
    -- local w = 0
    -- for _, line in ipairs(response) do
    --     log(response)
    --     if #line > w then w = #line end
    -- end

    vim.api.nvim_buf_set_text(buf, 0, 0, -1, 0, response)
    -- if row == nil then row = math.ceil((vim.o.lines - h - 2) * math.random()) end
    -- local col = math.ceil((vim.o.columns - w) * math.random())
    row = vim.o.lines - 6
    local col = 0
    local w = vim.o.columns

    local win = vim.api.nvim_open_win(buf, false, {
        col = col,
        row = row,
        relative = "editor",
        focusable = false,
        width = w,
        height = 2,
        border = "rounded",
        style = "minimal",
        title = "Cospaget",
        title_pos = "center",
    })

    -- vim.api.nvim_set_option_value("wrap", true, { win = win })
    vim.defer_fn(function() vim.api.nvim_win_close(win, true) end, 8000)
end

local feedback = function()
    local s = vim.fn.line("w0") - 1
    local e = vim.fn.line("w$") - 1

    local err = nil
    local hints = nil

    local diags = vim.diagnostic.get(0)
    local stabs = {}
    for _, d in ipairs(diags) do
        if d.lnum > s and d.lnum < e then table.insert(stabs, d) end
    end
    if #stabs > 0 then
        ---@type vim.Diagnostic
        err = stabs[math.random(#stabs)]
        hints = {
            "You should mention this diagnostic message:",
            err.message,
        }
    else
        local code = vim.api.nvim_buf_get_text(0, s, 0, e, -1, {})
        hints = {
            "You can pick on anything visible on screen at the moment:",
        }
        for _, l in ipairs(code) do
            table.insert(hints, l)
        end
    end

    local pt = {
        model = "llama3.2:latest",
        prompt = table.concat(preprompt(vim.bo.filetype, hints), "\n"),
        stream = false,
        keep_alive = "1m",
    }
    local args = { "curl", "-s", "http://10.0.2.2:11434/api/generate", "-d", vim.json.encode(pt) }

    log("Cospaget brewing...")
    vim.system(args, { text = true, clear_env = true, env = {} }, function(out)
        local ok, res = pcall(vim.json.decode, out.stdout)
        if not ok then
            log(out)
            return
        end
        local row = nil
        if err ~= nil then row = err.lnum - s + 1 end
        vim.schedule(function() open_prompt(res.response, row) end)
    end)
end

local max_interval_ms = 60 * 10 * 1000

local enabled = true

local function loop()
    if not enabled then return end
    feedback()
    vim.defer_fn(loop, math.random(max_interval_ms))
end

vim.api.nvim_create_user_command("Cospaget", feedback, {})
vim.api.nvim_create_user_command("CospagetToggle", function()
    enabled = not enabled
    if enabled then loop() end
end, {})

return M
