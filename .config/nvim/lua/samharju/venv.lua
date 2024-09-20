local log = require("samharju.dev").log

local M = {}

local virtual_env = os.getenv("VIRTUAL_ENV")
local venv_active = virtual_env ~= nil

local venv_exists = vim.fn.executable("venv/bin/python") == 1

local function available(venv, tool) return vim.fn.executable(venv .. "/bin/" .. tool) == 1 end

local version = ""

if venv_active then
    version = vim.fn.systemlist("python -V")[1]
elseif venv_exists then
    version = vim.fn.systemlist("venv/bin/python -V")[1]
else
    version = vim.fn.systemlist("python -V")[1]
end
version = version:match("Python (%d+.%d+.%d+)")

-- If venv exists, use tool from venv or disable totally
---@return boolean
function M.resolve(tool)
    -- if venv is active, use the tool if it's available
    if venv_active then return available(virtual_env, tool) end

    if venv_exists then return false end

    return vim.fn.executable(tool) == 1
end

function M.check_venv() return venv_active, venv_exists, version end

return M
