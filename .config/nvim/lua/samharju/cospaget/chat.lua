---@class ChatInstance
---@field buffer integer
---@field name string
---@field new fun(self:ChatInstance, name:string):ChatInstance
---@field use_callback fun(self:ChatInstance, callback:fun(self:ChatInstance))
---@field insert fun(self:ChatInstance, string)
---@field insert_partial fun(self:ChatInstance, string)
---@field update_pos fun(self:ChatInstance)
---@field insert_separator fun(self:ChatInstance, newline:boolean?)
---@field read fun(self:ChatInstance)
---@field step fun(self:ChatInstance)
---@field callback fun(self:ChatInstance)
local Chat = {
    callback = function(self)
        vim.print("chat callback called, state:")
        vim.print(self)
    end,
}

---@return ChatInstance
function Chat:new(name)
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, name)
    vim.cmd("split")
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

    local instance = {
        buffer = buf,
        pos = 1,
    }
    setmetatable(instance, { __index = Chat })

    return instance
end

function Chat:use_callback(callback)
    vim.keymap.set("n", "<CR>", function()
        self:read()
        callback(self)
    end, { buffer = self.buffer })
end

function Chat:insert(text)
    vim.api.nvim_buf_set_lines(self.buffer, -1, -1, false, vim.split(text, "\n"))
    self:update_pos()
end

function Chat:insert_partial(text) vim.api.nvim_buf_set_text(self.buffer, -1, -1, -1, -1, vim.split(text, "\n")) end

function Chat:update_pos() self.pos = #vim.api.nvim_buf_get_lines(self.buffer, 0, -1, false) end

function Chat:insert_separator(newline)
    local repl = { string.rep("_", 32) }
    if newline == true then table.insert(repl, "") end
    vim.api.nvim_buf_set_lines(self.buffer, -1, -1, false, repl)
    self:update_pos()
end

function Chat:read()
    local input = vim.api.nvim_buf_get_lines(self.buffer, self.pos - 1, -1, false)
    self.prompt = table.concat(input, "\n")
end

function Chat:step()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == self.buffer then
            vim.api.nvim_win_call(win, function() vim.fn.cursor(self.pos, 0) end)
        end
    end
end

return Chat
