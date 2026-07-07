return {
    "gbprod/yanky.nvim",
    requires = { "kkharji/sqlite.lua" },
    opts = {
        ring = { storage = "sqlite" }
    },
    keys = {
        { "<leader>p", "<cmd>YankyRingHistory<cr>",              mode = { "n", "x" },                                desc = "Open Yank History" },
        { "y",         "<Plug>(YankyYank)",                      mode = { "n", "x" },                                desc = "Yank text" },
        { "p",         "<Plug>(YankyPutAfter)",                  mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
        { "P",         "<Plug>(YankyPutBefore)",                 mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
        { "gp",        "<Plug>(YankyGPutAfter)",                 mode = { "n", "x" },                                desc = "Put yanked text after cursor and leave cursor after" },
        { "gP",        "<Plug>(YankyGPutBefore)",                mode = { "n", "x" },                                desc = "Put yanked text before cursor and leave cursor after" },
    },
    config = function()
        require("yanky").setup()
    end
}
