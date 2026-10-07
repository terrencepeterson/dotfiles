local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
local gitsigns = require("gitsigns")

-- one function taking {forward = bool}, wrapped so it records itself as last_move
local hunk_move = ts_repeat.make_repeatable_move(function(opts)
    if vim.wo.diff then
        vim.cmd.normal({ opts.forward and "]c" or "[c", bang = true })
    else
        gitsigns.nav_hunk(opts.forward and "next" or "prev")
    end
end)

vim.keymap.set("n", "<leader>gq", function()
    gitsigns.setqflist("all", { open = false })
end)

vim.keymap.set("n", "]c", function() hunk_move({ forward = true }) end)
vim.keymap.set("n", "[c", function() hunk_move({ forward = false }) end)

