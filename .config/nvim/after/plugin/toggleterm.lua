require("toggleterm").setup {
    open_mapping = [[<c-\>]],
    direction = 'vertical',
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
           return 100
            -- return vim.o.columns * 0.35
        end
    end,
}
