local commentApi = require('Comment.api')
require('Comment').setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
})
vim.keymap.set("n", "<C-_>", function() commentApi.toggle.linewise.current() end, { noremap = true, silent = true })
