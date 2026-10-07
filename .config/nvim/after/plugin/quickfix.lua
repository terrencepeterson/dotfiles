local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")

local quickfix_move = ts_repeat.make_repeatable_move(function(opts)
    pcall(vim.cmd, opts.forward and "cnext" or "cprev")
end)

vim.keymap.set("n", "]q", function() quickfix_move({ forward = true }) end)
vim.keymap.set("n", "[q", function() quickfix_move({ forward = false }) end)
