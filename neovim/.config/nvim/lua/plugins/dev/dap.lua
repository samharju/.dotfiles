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
vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticWarn", linehl = "", numhl = "DiagnosticWarn" })
vim.fn.sign_define(
    "DapStopped",
    { text = "→", texthl = "DiagnosticVirtualTextError", linehl = "", numhl = "DiagnosticError" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "R", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
)
return {
    {
        "mfussenegger/nvim-dap",
        version = false,
        dependencies = {
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = { only_first_definition = false, highlight_new_as_changed = true },
            },
        },
        keys = {
            { "<leader>bk", function() require("dap").continue() end, { desc = "dap continue" } },
            {
                "<C-down>",
                function()
                    require("dap").step_over()
                    vim.fn.feedkeys("zz")
                end,
                { desc = "dap step over" },
            },
            {
                "<C-right>",
                function()
                    require("dap").step_into()
                    vim.fn.feedkeys("zz")
                end,
                { desc = "dap step in" },
            },
            {
                "<C-left>",
                function()
                    require("dap").step_out()
                    vim.fn.feedkeys("zz")
                end,
                { desc = "dap step out" },
            },
            { "<leader>bb", function() require("dap").toggle_breakpoint() end, { desc = "dap toggle breakpoint" } },
            { "<leader>br", function() require("dap").run_last() end, { desc = "dap rerun last" } },
            { "<leader>bc", function() require("dap").close() end, { desc = "dap close" } },
            { "<C-up>", function() require("dap.ui.widgets").hover() end, { desc = "dap hover" } },
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
    {
        "igorlfs/nvim-dap-view",
        opts = {},
    },
}
