local M = {}

M.read_file = {
    schema = {
        type = "function",
        ["function"] = {
            name = "read_file",
            description = "Read contents of the file.",
            parameters = {
                type = "object",
                properties = {
                    filename = { type = "string", description = "The name of the file to read." },
                },
            },
        },
    },
    callback = function(args)
        local fname = args.filename

        local w = io.open(fname, "r")
        if w == nil then return end
        local contents = w:read("*a")
        w:close()
        return contents
    end,
}

return M
