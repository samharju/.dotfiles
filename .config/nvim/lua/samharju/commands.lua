local cmd = vim.api.nvim_create_user_command

-- cmon not an editor command: W
cmd("W", "w", {})

cmd("Breakpoints", function() vim.cmd([[ grep -F 'breakpoint()' ]]) end, {})

-- clear registers
cmd("ClearRegs", function(_)
    local regs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for r in regs:gmatch(".") do
        local val = vim.fn.getreg(r)
        if val ~= "" then vim.fn.setreg(r, "") end
    end
end, { desc = "Clear registers abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" })

cmd(
    "DiagnosticToggle",
    function(_) vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
    { desc = "Toggle diagnostics" }
)

local function bg_none(name, hl) vim.api.nvim_set_hl(0, name, { fg = hl.fg, bg = nil, italic = hl.italic }) end

cmd("ColorMyPencils", function()
    bg_none("Normal", vim.api.nvim_get_hl(0, { name = "Normal" }))
    bg_none("NormalFloat", vim.api.nvim_get_hl(0, { name = "NormalFloat" }))
    bg_none("EndOfBuffer", vim.api.nvim_get_hl(0, { name = "EndOfBuffer" }))
    bg_none("TablineFill", vim.api.nvim_get_hl(0, { name = "TablineFill" }))
end, {})

local grp = vim.api.nvim_create_augroup("sharju_commands", { clear = true })

local function show_diff()
    local res = vim.fn.system("git status --porcelain")
    if res ~= "" then
        if string.match(res, "fatal") then return false end
        return true
    end
    return false
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = grp,
    pattern = "*",
    callback = function() vim.fn.matchadd("Function", [[TODO\|FIXME\|\<FIX\>]], 100) end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = grp,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Search",
            timeout = 100,
        })
    end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = grp,
--     pattern = "*",
--     command = [[%s/\s\+$//e]],
-- })

-- open telescope on enter if no args given
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         if vim.g.session_restored then return end
--         local arg = vim.api.nvim_eval("argv(0)")
--         if arg and arg == "" then
--             if show_diff() then
--                 require("telescope.builtin").git_status()
--             else
--                 require("telescope.builtin").find_files()
--             end
--         end
--     end,
-- })
