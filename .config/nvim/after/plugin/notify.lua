local notify = require('notify')
vim.keymap.set({ 'n', 'v' }, '<leader>md', function()
    notify.dismiss()
end)
