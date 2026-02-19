vim.keymap.set("i", "jk", "<ESC>")

-- wrap selection into quotes
vim.keymap.set("v", "<leader>s'", "c'<C-r>\"'<Esc>")
vim.keymap.set("v", '<leader>s"', 'c"<C-r>""<Esc>')
vim.keymap.set("v", "<leader>s(", 'c(<C-r>")<Esc>')
vim.keymap.set("v", "<leader>s[", 'c[<C-r>"]<Esc>')
vim.keymap.set("v", "<leader>s{", 'c{<C-r>"}<Esc>')

-- move block nicely
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- keep stuff centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>P", '"+P')

vim.keymap.set("n", "<leader>i", ":Inspect<CR>")

vim.keymap.set("n", "]q", ":cnext<CR>zz", { silent = true })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { silent = true })
vim.keymap.set("n", "]c", ":lnext<CR>zz", { silent = true })
vim.keymap.set("n", "[c", ":lprev<CR>zz", { silent = true })

local nustate = 0
vim.keymap.set("n", "<leader>'", function()
    nustate = nustate + 1
    if nustate > 2 then nustate = 0 end

    if nustate == 0 then
        vim.o.number = true
        vim.o.relativenumber = false
    elseif nustate == 1 then
        vim.o.number = true
        vim.o.relativenumber = true
    else
        vim.o.number = false
        vim.o.relativenumber = false
    end
end)

-- back and forth
vim.keymap.set("n", "<leader>;", "<C-^>", { desc = "alt buffer" })

vim.keymap.set(
    "n",
    "<leader>q",
    function() vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } }) end,
    { desc = "Diagnostic qf" }
)
vim.keymap.set(
    "n",
    "<leader>d",
    function() vim.diagnostic.setloclist({ severity = { min = vim.diagnostic.severity.WARN } }) end,
    { desc = "Diagnostic loclist" }
)

-- lsp 0.11 ,appings:
-- grn N vim.lsp.buf.rename()
-- grr N vim.lsp.buf.references()
-- gri N vim.lsp.buf.implementation()
-- gO  N vim.lsp.buf.document_symbol()
-- gra NV vim.lsp.buf.code_action()
-- grt N vim.lsp.buf.type_definition()
vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set({ "n", "i", "s" }, "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end)

local crumb_buf = nil
local crumb_win = -1

local function crumbs(patterns)
    local n = vim.treesitter.get_node()

    local stack = {}
    while n ~= nil do
        local t = n:type()
        for _, p in ipairs(patterns) do
            if t:find(p) then
                local l = vim.split(vim.treesitter.get_node_text(n, 0), "\n")[1]
                if stack[#stack] ~= l then table.insert(stack, l) end
                break
            end
        end

        n = n:parent()
    end
    local nodes = {}
    local len = 0
    for i, txt in ipairs(stack) do
        local padding = string.rep(" ", vim.bo.shiftwidth)
        local r = string.rep(padding, #stack - i) .. txt
        table.insert(nodes, 1, r)
        if #r > len then len = #r end
    end
    return nodes, len
end

vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("asd", { clear = true }),
    callback = function(_)
        if vim.api.nvim_win_is_valid(crumb_win) then vim.api.nvim_win_close(crumb_win, false) end
    end,
})

vim.keymap.set("n", "<C-j>", function()
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
    })
    if #lines == 0 then return end

    if crumb_buf == nil then crumb_buf = vim.api.nvim_create_buf(false, true) end
    vim.api.nvim_buf_set_lines(crumb_buf, 0, -1, false, lines)
    vim.api.nvim_set_option_value("ft", vim.bo.filetype, { buf = crumb_buf })
    vim.diagnostic.enable(false, { bufnr = crumb_buf })

    local pos = vim.fn.getcharpos(".")
    crumb_win = vim.api.nvim_open_win(crumb_buf, false, {
        relative = "cursor",
        width = w + 2,
        height = #lines,
        row = -2 - #lines,
        col = -pos[3],
        border = "rounded",
        style = "minimal",
    })
end)

-- local asdapasda = vim.api.nvim_create_namespace("asdapasdagasda")
--
-- vim.api.nvim_create_autocmd("CursorMoved", {
--     group = vim.api.nvim_create_augroup("asd", { clear = true }),
--     callback = function(_) vim.api.nvim_buf_clear_namespace(0, asdapasda, 0, -1) end,
-- })
-- vim.keymap.set("n", "<C-j>", function()
--     vim.api.nvim_buf_clear_namespace(0, asdapasda, 0, -1)
--     local nodes, _ = crumbs({ "class", "method", "function", "if_st", "else", "elif", "for_st", "switch", "call" })
--     local p = vim.api.nvim_win_get_cursor(0)
--     local hl = "DiagnosticVirtualLinesHint"
--     local lines = { { { "", hl } } }
--     for _, n in ipairs(nodes) do
--         table.insert(lines, { { "\t" .. n, hl } })
--     end
--     table.insert(lines, { { "", hl } })
--
--     vim.api.nvim_buf_set_extmark(0, asdapasda, p[1] - 1, p[2], {
--         virt_lines = lines,
--         virt_lines_above = true,
--     })
-- end)
