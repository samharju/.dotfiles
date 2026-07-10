local logfile = vim.fn.stdpath("cache") .. "/dotfiles.log"

local M = {}

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

if os.getenv("DOTFILES_DEBUG") == nil then
    M.log = function() end
else
    M.log = log
end

return M
