return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
        require("oil").setup({
            view_options = {
                show_hidden = true
            },
            win_options = {
                signcolumn = "yes:2"
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["<C-p>"] = false
            },
        })
        vim.keymap.set("n", "-", "<CMD>Oil --preview<CR>", { desc = "Open parent directory" })
        local cwd = vim.fn.getcwd(0, 0)
        vim.keymap.set("n", "~", "<CMD>Oil --preview " .. cwd .. " <CR>", { desc = "Open current working directory" })
    end
}
