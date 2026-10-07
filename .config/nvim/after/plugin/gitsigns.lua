local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
local gitsigns = require("gitsigns")

-- one function taking {forward = bool}, wrapped so it records itself as last_move
local hunk_move = ts_repeat.make_repeatable_move(function(opts)
    gitsigns.nav_hunk(opts.forward and "next" or "prev", { navigation_message = false })
end)

vim.keymap.set("n", "<leader>gq", function()
    gitsigns.toggle_deleted(true)   -- show removed lines inline (virtual lines)
    gitsigns.toggle_linehl(true)    -- highlight added/changed lines
    gitsigns.toggle_word_diff(true) -- highlight the exact words that changed
    gitsigns.setqflist("all", { open = false })
end)

vim.keymap.set("n", "<leader>gQ", function()
    gitsigns.toggle_deleted(false)
    gitsigns.toggle_linehl(false)
    gitsigns.toggle_word_diff(false)
end)



vim.keymap.set("n", "]c", function() hunk_move({ forward = true }) end)
vim.keymap.set("n", "[c", function() hunk_move({ forward = false }) end)
