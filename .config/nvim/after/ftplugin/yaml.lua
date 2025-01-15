if string.match(vim.fn.expand("%:t"), "compose") then vim.bo.filetype = "yaml.docker-compose" end

if string.match(vim.fn.expand("%:p"), "ansible") then vim.bo.filetype = "yaml.ansible" end

vim.opt_local.listchars = { leadmultispace = "▏ " }
