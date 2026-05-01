local notify = require('notify')
notify.setup({
    background_colour = "#000000",
})

vim.keymap.set({ 'n', 'v' }, '<leader>cm', function()
    notify.dismiss()
end, { desc = "Clear messages - removes all messages from screen" })
