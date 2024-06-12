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
        require("dap-go").setup()

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
            },
        }

        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dh", dap.step_out)
        vim.keymap.set("n", "<leader>dj", dap.step_over)
        vim.keymap.set("n", "<leader>dk", dap.continue)
        vim.keymap.set("n", "<leader>dl", dap.step_into)
        vim.keymap.set("n", "<leader>dr", dap.restart)
        vim.keymap.set("n", "<leader>do", dap.repl.open)
        vim.keymap.set("n", "<leader>dw", require("dap.ui.widgets").hover)
    end,
}
