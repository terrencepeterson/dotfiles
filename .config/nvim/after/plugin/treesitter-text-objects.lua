local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
local textObjectsSelect = require "nvim-treesitter-textobjects.select"

require("nvim-treesitter-textobjects").setup {
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        set_jumps = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
    },
}

vim.keymap.set({ "x", "o" }, "al", function()
    textObjectsSelect.select_textobject("@loop.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "il", function()
    textObjectsSelect.select_textobject("@loop.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "af", function()
    textObjectsSelect.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
    textObjectsSelect.select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ai", function()
    textObjectsSelect.select_textobject("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ii", function()
    textObjectsSelect.select_textobject("@conditional.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
    textObjectsSelect.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
    textObjectsSelect.select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "a#", function()
    textObjectsSelect.select_textobject("@comment.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "i#", function()
    textObjectsSelect.select_textobject("@comment.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
    textObjectsSelect.select_textobject("@local.scope", "locals")
end)

-- MOVE
vim.keymap.set({ "n", "x", "o" }, "]f", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[f", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]i", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[i", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]l", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[l", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
