local cmd = vim.api.nvim_create_user_command

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

local function firstToUpper(str) return (str:gsub("^%l", string.upper)) end

local function genline(w, t)
    w = math.min(w, 6)
    local line = {}
    for j = 0, math.random(w), 1 do
        table.insert(line, t[math.random(#t)])
    end
    local _end = { ".", ".", ".", ".", ".", ".", "!", "?", "..." }
    return firstToUpper(table.concat(line, " ")) .. _end[math.random(#_end)]
end

-- local t = { "󰮕", "󰵛", "󰦤", "󱠇", "󰽒", "󱌸", "󰩹", "󱡂" }
local t = {
    "for",
    "not",
    "over",
    "before",
    "and",
    "or",
    "to",
    "jump",
    "AI",
    "genAI",
    "cospaget",
    "spagetti",
    "gptchat",
    "cyclesuper",
    "supercycle",
    "profit",
    "embrace",
    "10x",
    "leverage",
    "empower",
    "dev",
    "agentic",
    "workflow",
    "synergy",
    "scale",
    "iterate",
    "disrupt",
    "optimize",
    "streamline",
    "innovate",
    "automate",
    "accelerate",
    "monetize",
    "pivot",
    "growth",
    "velocity",
    "alignment",
    "impact",
    "outcomes",
    "ecosystem",
    "platform",
    "cloud",
    "native",
    "frictionless",
    "seamless",
    "nextgen",
    "hyperlocal",
    "paradigm",
    "flywheel",
    "moat",
    "vision",
    "roadmap",
    "unlock",
    "transform",
    "enable",
}

local token_len = 0

for _, v in ipairs(t) do
    if #v > token_len then token_len = #v end
end

local function populate(win, buf, lines)
    local w = math.floor(vim.api.nvim_win_get_width(win) / token_len)
    local h = vim.api.nvim_win_get_height(win) - 2

    for i = 0, h, 1 do
        local line = {}
        for j = 0, math.random(w), 1 do
            table.insert(line, t[math.random(#t)])
        end
        table.insert(lines, genline(w, t))
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

vim.api.nvim_create_user_command("CursorCA2Review", function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

    local win = vim.api.nvim_open_win(buf, false, { split = "left", win = 0 })
    local churning = true
    local lines = {}

    local start = os.time()
    local function update()
        local end_ = os.time() - start
        lines = table.slice(lines, 3)
        table.insert(lines, 1, string.format("runtime: %sm %ss", math.floor(end_ / 60), end_ % 60))
        local line = {}
        local w = math.floor(vim.api.nvim_win_get_width(win) / token_len)
        for j = 0, math.random(w), 1 do
            table.insert(line, t[math.random(#t)])
        end
        table.insert(lines, genline(w, t))
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    local function loop()
        if not churning or not vim.api.nvim_buf_is_valid(buf) then return end
        update()
        vim.defer_fn(loop, math.random(25, 1000))
    end

    local function prompt()
        vim.system({
            "agent",
            "--mode=ask",
            "--model=gpt-5.5-extra-high",
            "--force",
            "@~/.cursor/skills/ca2-review/SKILL.md /ca2-review",
            "--print",
        }, { text = true }, function(out)
            local end_ = os.time() - start
            churning = false
            if out.code ~= 0 then
                vim.print("CursorCA2Review failed: ", out.stderr or "")
                return
            end
            local lines_ = vim.split(out.stdout, "\n")
            table.insert(lines_, 1, "")
            table.insert(lines_, 1, string.format("runtime: %sm %ss", math.floor(end_ / 60), end_ % 60))
            vim.schedule(function() vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_) end)
        end)
    end
    populate(win, buf, lines)
    loop()
    prompt()
end, {})

cmd("CursorWez", function(_)
    local cwd = vim.uv.cwd()
    vim.system({ "wezterm", "start", "--cwd", cwd, "agent" })
end, {})

cmd("CursorTmux", function(_) vim.system({ "tmux", "splitw", "-h", "agent" }) end, {})

local function context()
    vim.cmd.normal("!<Esc>")
    local start = vim.fn.getpos("'<")
    local finish = vim.fn.getpos("'>")

    local output = {}
    local lines = vim.fn.getline(start[2], finish[2])

    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    table.insert(output, 1, "@" .. name)
    table.insert(output, 2, string.format("line %d", start[2]))
    table.insert(output, 3, "---")
    local text = table.concat(output, "\n")
    if type(lines) == "string" then lines = { lines } end
    local c = string.format("%s\n%s\n---", text, table.concat(lines, "\n"))
    vim.fn.setreg("+", c)
    vim.notify("saved context to clipboard")
end

vim.keymap.set({ "n", "v" }, "<leader>cc", context)
