if string.match(vim.fn.expand("%:t"), "docker%-compose") then vim.bo.filetype = "yaml.docker-compose" end

if string.match(vim.fn.expand("%:h"), "ansible") then
    vim.bo.filetype = "yaml.ansible"
else
    local content = vim.api.nvim_buf_get_lines(0, 0, 30, false) or { "" }
    for _, value in ipairs(content) do
        if string.find(value, "ansible.builtin") then
            vim.bo.filetype = "yaml.ansible"
            break
        end
    end
end

vim.opt_local.listchars = { leadmultispace = "▏ " }
