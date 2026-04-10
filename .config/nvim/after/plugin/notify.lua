local notify = require('notify')
notify.setup({
    background_colour = "#000000",
})

vim.keymap.set({ 'n', 'v' }, '<leader>md', function()
    notify.dismiss()
end)
