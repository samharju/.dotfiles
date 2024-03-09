local cmd = vim.api.nvim_create_user_command

-- cmon not an editor command: W
cmd("W", "w", {})

-- clear registers
cmd("ClearRegs", function(_)
    local regs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for r in regs:gmatch(".") do
        local val = vim.fn.getreg(r)
        if val ~= "" then vim.fn.setreg(r, "") end
    end
end, { desc = "Clear registers abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" })

local virtual_text = true
cmd("FlipVirtualText", function(_)
    if virtual_text then
        vim.diagnostic.config({
            virtual_text = false,
        })
        virtual_text = false
    else
        vim.diagnostic.config({
            virtual_text = { source = "if_many" },
        })
        virtual_text = true
    end
end, { desc = "Toggle virtual text diagnostics" })

local grp = vim.api.nvim_create_augroup("sharju_commands", { clear = true })

local function show_diff()
    local res = vim.fn.system("git status --porcelain")
    if res ~= "" then
        if string.match(res, "fatal") then return false end
        return true
    end
    return false
end

vim.api.nvim_create_autocmd("TextYankPost", {
    group = grp,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Search",
            timeout = 50,
        })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = grp,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- open telescope on enter if no args given
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local arg = vim.api.nvim_eval("argv(0)")
        if arg and arg == "" then
            if show_diff() then
                require("telescope.builtin").git_status()
            else
                require("telescope.builtin").find_files({
                    layout_strategy = "center",
                    layout_config = {},
                    previewer = false,
                    prompt_title = vim.fn.getcwd(),
                    hidden = true,
                })
            end
        end
    end,
})
