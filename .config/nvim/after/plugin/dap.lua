local dap = require('dap')
-- require('telescope').load_extension('dap')

dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" }
}

dap.configurations.php = {
    {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9000,
        pathMappings = {
            ["/webroot"] = vim.loop.cwd() .. "/magento"
        }
    }
}

vim.keymap.set('n', '<leader>dl', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>dso', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>dsi', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>dso', function() require('dap').step_out() end)
vim.keymap.set('n', '<leader>dtb', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dsb', function() require('dap').set_breakpoint() end)
-- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end)
-- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
