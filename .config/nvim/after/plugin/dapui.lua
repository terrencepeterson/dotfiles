local dapui = require("dapui")
dapui.setup({})

vim.keymap.set("n", "<leader>dui", function()
    dapui.toggle()
end, { desc = "Toggle dap ui" })

