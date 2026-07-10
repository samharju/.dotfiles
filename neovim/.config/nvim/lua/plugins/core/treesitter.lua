local is_big = function(_, bufnr)
    local ok, s = pcall(function() return vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr)) end)
    if not ok then return false end
    if not s then return false end

    return s.size > 1000000
end

return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    version = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = is_big,
            },
            autotag = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader><CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<BS>",
                },
            },
        })
    end,
}
