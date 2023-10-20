local function create_env()
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.cmd.te()
    local term_id = vim.api.nvim_buf_get_var(0, "terminal_job_id")
    vim.api.nvim_buf_set_name(0, "latch: " .. term_id)
    vim.api.nvim_set_current_buf(cur_buf)
    return term_id
end

local function execute(term_id, command)
    vim.api.nvim_chan_send(term_id, command .. '\n')
end

local function buf_check_term_id(buf)
    return vim.api.nvim_buf_get_var(buf, "terminal_job_id")
end
local function select_term()
    local term_bufs = {}
    local buffers = vim.api.nvim_list_bufs()
    for _, value in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(value) then
            local ok, term_id = pcall(buf_check_term_id, value)
            if ok then
                table.insert(term_bufs, term_id)
            end
        end
    end
    local term_id = 0
    vim.ui.select(term_bufs, { prompt = "Select target: " }, function(item, idx)
        term_id = item
    end)
    return term_id
end


local function dump(asd, indent)
    for key, value in pairs(asd) do
        if (type(value) == "table") then
            -- do stuff
            print(indent .. key .. ":")
            dump(value, indent .. "  ")
        else
            print(indent .. key .. ": " .. value)
        end
    end
end
-- local asd = create_env()
-- execute(asd, "echo hello")
local target = select_term()
local info = vim.api.nvim_get_chan_info(target)
dump(info, "")
-- execute(target, "echo hello")

