return {
    'nvim-telescope/telescope.nvim',
    version = "*",
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            -- This will not install any breaking changes.
            -- For major updates, this must be adjusted manually.
            version = "^1.0.0",
        },
        {
            "nvim-telescope/telescope-smart-history.nvim",
            dependencies = {
                "kkharji/sqlite.lua"
            },
        }
    }
}
