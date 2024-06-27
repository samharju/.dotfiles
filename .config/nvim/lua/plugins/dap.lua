local function resolve_python_cwd()
    local p = vim.fs.find({ "tests", "test" }, { type = "directory", limit = 1 })
    if p then return vim.fn.fnamemodify(p[1], ":h") end
end

local python_cwd = resolve_python_cwd()

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
        "leoluz/nvim-dap-go",
        "nvim-neotest/nvim-nio",
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                commented = true,
                highlight_changed_variables = true,
                all_frames = true,
                virt_text_pos = "eol",
            },
        },
    },
    config = function()
        local dap = require("dap")

        require("dap-python").setup()
        require("dap-python").test_runner = "pytest"

        require("dap-go").setup()

        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dh", dap.step_out)
        vim.keymap.set("n", "<leader>dj", dap.step_over)
        vim.keymap.set("n", "<leader>dk", dap.continue)
        vim.keymap.set("n", "<leader>dl", dap.step_into)
        vim.keymap.set("n", "<leader>dr", dap.restart)
        vim.keymap.set("n", "<leader>do", dap.repl.open)
        vim.keymap.set("n", "<leader>dw", require("dap.ui.widgets").hover)

        vim.keymap.set("n", "<leader>dt", function()
            vim.notify("Debugging test", "info", { title = "DAP" })
            require("dap-python").test_method({ config = { cwd = python_cwd } })
        end)
    end,
}
