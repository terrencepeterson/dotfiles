return {
    {
        'tpope/vim-fugitive',
        config = function()
            -- we open these in new tabs so they can all be full width and then when we close them
            -- it takes you back to the most recent window that you had open
            vim.keymap.set("n", "<leader>ga", vim.cmd.Gwrite)
            vim.keymap.set("n", "<leader>gs", ":tab G<CR>", { silent = true})
            vim.keymap.set("n", "<leader>gc", ":tab Git commit<CR>", { silent = true})
            vim.keymap.set("n", "<leader>gl", ":tab Git log<CR>", { silent = true})
            vim.keymap.set("n", "<leader>gh", ":tab Git log -- %<CR>", { silent = true})
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                on_attach = function()
                    vim.cmd("highlight GitSignsAdd guifg=#B9BA33")
                    vim.cmd("highlight GitSignsDelete guifg=#F94C3A")
                end
            })

            vim.keymap.set("n", "<leader>gt", ":Gitsigns preview_hunk_inline<CR>", {})
            vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {})
        end
    }
}
