if vim.fn.filereadable("Session.vim") == 1 then
    vim.g.session_restored = true
    vim.api.nvim_create_autocmd("VimLeave", {
        group = vim.api.nvim_create_augroup("sami_session", { clear = true }),
        callback = function()
            vim.cmd("mksession! Session.vim")
            vim.cmd("wshada! Session.shada")
        end,
    })
    vim.cmd("source Session.vim")
    if vim.fn.filereadable("Session.shada") == 1 then vim.cmd("rshada! Session.shada") end
end
