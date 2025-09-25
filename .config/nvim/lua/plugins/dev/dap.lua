--
-- nvim-dap uses five signs:
--
-- - `DapBreakpoint` for breakpoints (default: `B`)
-- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- - `DapLogPoint` for log points (default: `L`)
-- - `DapStopped` to indicate where the debugee is stopped (default: `→`)
-- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug
--   adapter (default: `R`)
--
-- You can customize the signs by setting them with the |sign_define()| function.
-- For example:
--
-- >
-- >lua
--   vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
--
vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticInfo", linehl = "", numhl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn", linehl = "", numhl = "DiagnosticWarn" })
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "R", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
)
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { { "theHamsta/nvim-dap-virtual-text", opts = {} } },
        keys = {
            { "<leader>bk", function() require("dap").continue() end },
            { "<leader>bj", function() require("dap").step_over() end },
            { "<leader>bl", function() require("dap").step_into() end },
            { "<leader>bh", function() require("dap").step_out() end },
            { "<leader>bb", function() require("dap").toggle_breakpoint() end },
            { "<leader>br", function() require("dap").run_last() end },
            { "<leader>bv", function() require("dap.ui.widgets").hover() end },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = "python",
        config = function(opts)
            local d = os.getenv("XDG_DATA_HOME")
            local dappy = require("dap-python")
            dappy.setup(d .. "/debugpyvenv/bin/python")
        end,
    },

    {
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        lazy = true,
        config = function() require("dap-go").setup() end,
    },
}
