local is_big = function(_, bufnr)
    local ok, s = pcall(function() return vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr)) end)
    if not ok then return false end
    if not s then return false end

    return s.size > 1000000
end
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        local available_langs = require("nvim-treesitter").get_available()
        local is_available = vim.tbl_contains(available_langs, lang)
        if is_available then
            local installed_langs = require("nvim-treesitter").get_installed()
            local installed = vim.tbl_contains(installed_langs, lang)
            if not installed then require("nvim-treesitter").install(lang):wait() end
            vim.treesitter.start()
            require("nvim-treesitter").indentexpr()
        end
    end,
})
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- config = function()
    --     require("nvim-treesitter.configs").setup({
    --         auto_install = true,
    --         highlight = {
    --             enable = true,
    --             additional_vim_regex_highlighting = false,
    --             disable = is_big,
    --         },
    --         autotag = {
    --             enable = true,
    --         },
    --         incremental_selection = {
    --             enable = true,
    --             keymaps = {
    --                 init_selection = "<leader><CR>",
    --                 node_incremental = "<CR>",
    --                 node_decremental = "<BS>",
    --             },
    --         },
    --     })
    -- end,
}
