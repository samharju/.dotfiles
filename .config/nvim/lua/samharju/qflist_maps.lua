-- iterate quick- and loclist
vim.keymap.set("n", "[q", function()
    local qf = vim.fn.getqflist()
    if #qf == 0 then return end
    if #qf == 1 or vim.fn.getqflist({ idx = 0 }).idx == 1 then
        vim.cmd.clast()
        return
    end
    vim.cmd.cprev()
end, { desc = "Previous quickfix" })

vim.keymap.set("n", "]q", function()
    local qf = vim.fn.getqflist()
    if #qf == 0 then return end
    if #qf == 1 or vim.fn.getqflist({ idx = 0 }).idx == #qf then
        pcall(vim.cmd.cfirst)
        return
    end
    pcall(vim.cmd.cnext)
end, { desc = "Next quickfix" })

vim.keymap.set("n", "[l", function()
    local lf = vim.fn.getloclist(0)
    if #lf == 0 then return end
    if vim.fn.getloclist(0, { idx = 0 }).idx == 1 then
        pcall(vim.cmd.llast)
        return
    end
    pcall(vim.cmd.lprev)
end, { desc = "Previous on loclist" })

vim.keymap.set("n", "]l", function()
    local lf = vim.fn.getloclist(0)
    if #lf == 0 then return end
    if vim.fn.getloclist(0, { idx = 0 }).idx == #lf then
        pcall(vim.cmd.lfirst)
        return
    end
    pcall(vim.cmd.lnext)
end, { desc = "Next on loclist" })

vim.keymap.set("n", "]a", function()
    vim.cmd.caddexpr([[expand("%") .. ":" .. line(".") .. ":" .. col(".") ..  ":" .. getline(".")]])
    vim.cmd.copen()
    vim.cmd("wincmd p")
end, { desc = "Add current pos to quickfix" })

vim.keymap.set("n", "[a", function()
    vim.cmd.laddexpr([[expand("%") .. ":" .. line(".") .. ":" .. col(".") ..  ":" .. getline(".")]])
    vim.cmd.lopen()
    vim.cmd("wincmd p")
end, { desc = "Add current pos to loclist" })

