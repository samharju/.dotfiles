local M = {}

local virtual_env = os.getenv("VIRTUAL_ENV")
local venv_active = virtual_env ~= nil

local function venv_exists() return vim.fn.executable("venv/bin/python") == 1 end

local function available(venv, tool) return vim.fn.executable(venv .. "/bin/" .. tool) == 1 end

local venv = false
local version = ""
local exists = venv_exists()

if venv_active then
    version = vim.fn.systemlist("python -V")[1]
    venv = true
elseif exists then
    version = vim.fn.systemlist("venv/bin/python -V")[1]
    venv = true
else
    version = vim.fn.systemlist("python -V")[1]
    venv = false
end
version = version:match("Python (%d+.%d+.%d+)")

-- If venv exists, use tool from venv or disable totally
---@return boolean, string
function M.resolve(tool)
    if tool == "virtualenv" then
        if vim.api.nvim_get_option_value("filetype", { buf = 0 }) ~= "python" then return false, "" end
        return venv, version
    end
    if venv_active then
        if available(virtual_env, tool) then return true, tool end
        return false, ""
    end

    if venv_exists() then
        if available("venv", tool) then return true, "venv/bin/" .. tool end
        return false, ""
    end

    if vim.fn.executable(tool) == 1 then return true, tool end
    return false, ""
end

function M.check_venv() return venv_active, exists, version end

return M
