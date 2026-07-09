local M = {}
local crumb_buf = nil
local crumb_win = -1

local function crumbs(patterns, named_only)
    local n = vim.treesitter.get_node()

    local stack = {}
    while n ~= nil do
        local t = n:type()
        for _, p in ipairs(patterns) do
            if t:find(p) then
                if named_only then
                    if n:named() then
                        for _, nnn in ipairs(n:field("name")) do
                            local text = vim.treesitter.get_node_text(nnn, 0)
                            if stack[#stack] ~= text then table.insert(stack, text) end
                        end
                    end
                else
                    local l = vim.split(vim.treesitter.get_node_text(n, 0), "\n")[1]
                    if stack[#stack] ~= l then table.insert(stack, l) end
                end
                break
            end
        end

        n = n:parent()
    end
    if named_only then
        local parts = {}
        for _, v in ipairs(stack) do
            table.insert(parts, 1, v)
        end
        local s = table.concat(parts, " -> ")
        return { s }, #s
    end

    local parts = {}
    local len = 0
    for i, txt in ipairs(stack) do
        local padding = string.rep(" ", vim.bo.shiftwidth)
        local r = string.rep(padding, #stack - i) .. txt
        table.insert(parts, 1, r)
        if #r > len then len = #r end
    end

    return parts, len
end

local function show(lines, w)
    if crumb_buf == nil then crumb_buf = vim.api.nvim_create_buf(false, true) end
    vim.treesitter.stop(crumb_buf)
    vim.api.nvim_buf_set_lines(crumb_buf, 0, -1, false, lines)
    vim.api.nvim_set_option_value("ft", vim.bo.filetype, { buf = crumb_buf })
    vim.diagnostic.enable(false, { bufnr = crumb_buf })

    local pos = vim.fn.getcharpos(".")
    crumb_win = vim.api.nvim_open_win(crumb_buf, false, {
        relative = "cursor",
        width = w,
        height = #lines,
        row = -2 - #lines,
        col = -pos[3],
        border = "rounded",
        style = "minimal",
    })
end
function M.crumbs_show_named()
    if vim.api.nvim_win_is_valid(crumb_win) then return end
    local lines, w = crumbs({
        "class",
        "method",
        "function",
        "if_st",
        "else",
        "elif",
        "for_st",
        "switch",
        "call",
        "except_clause",
    }, true)
    if #lines == 0 then return end
    show(lines, w)
end

local ns = vim.api.nvim_create_namespace("samharju_crumbs")

function M.crumbs_show_virt()
    local lines, w = crumbs({
        "class",
        "method",
        "function",
        "if_st",
        "else",
        "elif",
        "for_st",
        "switch",
        "call",
        "except_clause",
    }, true)
    if #lines == 0 then return end
    local pos = vim.api.nvim_win_get_cursor(0)
    local virt_lines = {
        { lines[1], "DiagnosticVirtualTextInfo" },
    }
    vim.api.nvim_buf_set_extmark(0, ns, pos[1] - 1, pos[2], { virt_text = virt_lines })
end

function M.crumbs_show_context()
    if vim.api.nvim_win_is_valid(crumb_win) then return end
    local lines, w = crumbs({
        "class",
        "method",
        "function",
        "if_st",
        "else",
        "elif",
        "for_st",
        "switch",
        "call",
        "except_clause",
    }, false)
    if #lines == 0 then return end
    show(lines, w)
end

function M.status()
    local lines, _ = crumbs({
        "class",
        "method",
        "function",
        "if_st",
        "else",
        "elif",
        "for_st",
        "switch",
        "call",
        "except_clause",
    }, true)
    if #lines == 0 then return "" end
    return lines[1]
end
local au = vim.api.nvim_create_augroup("samharju_crumbs_au", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
    group = au,
    callback = function(_)
        if vim.api.nvim_win_is_valid(crumb_win) then vim.api.nvim_win_close(crumb_win, false) end
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end,
})

return M
