local filename = vim.fn.expand("%:t")

if string.match(filename, "compose") then vim.bo.filetype = "yaml.docker-compose" end
