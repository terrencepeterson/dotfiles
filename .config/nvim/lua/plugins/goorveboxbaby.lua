_G.GetWinBar = function()
    if vim.w.is_current then return "" end
    local relativePath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
    local filename = vim.fn.expand("%:t")
    local cleanPath = relativePath:gsub("oil:///home/matt/projects/", "")
    cleanPath = filename == cleanPath and "" or cleanPath -- stops file path from showing twice when editing files at project level
    local extension = vim.fn.expand("%:e")
    local devIcon, devIconHighlight = require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
    return string.format("  %%#%s#%s  %%#WinBarFileName#%s %%#WinBarPath#%s", devIconHighlight, devIcon, filename, cleanPath);
end

return {
    'luisiacc/gruvbox-baby',
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        -- Enable telescope theme
        vim.g.gruvbox_baby_telescope_theme = 1
        -- Enable transparent mode
        vim.g.gruvbox_baby_transparent_mode = 1
        vim.g.gruvbox_baby_keyword_style = "NONE"

        -- Load the colorscheme
        vim.cmd[[colorscheme gruvbox-baby]]

        -- Set background colour
        vim.api.nvim_set_hl(0, "Normal", { bg = "#323232" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#323232" })
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

        -- set the current line number to bold yellow
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#564E48', bold=false })
        vim.api.nvim_set_hl(0, 'LineNr', { fg='#EEBD35', bold=true })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#564E48', bold=false })

        -- set tab indent line colour
        -- vim.api.nvim_set_hl(0, "IblIndent", { fg = "#4a4746" })
        vim.api.nvim_set_hl(0, "NonText", { fg = "#3b3837" })

        -- vim.cmd [[highlight StatusLine guibg=#282c34 guifg=#ffffff]]
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#323232", fg = "#ffffff" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#323232", fg = "#ffffff" })

        -- vim.wo.winbar = "%{%v:lua.GetWinBar()%}"
        vim.api.nvim_set_hl(0, "WinBar", { bg = "#3a3a3a", fg = "#ffffff" })
        -- vim.api.nvim_set_hl(0, "WinBarFileName", { bold = true })
        vim.api.nvim_set_hl(0, "WinBarPath", { italic = true, fg = "#8a7f78" })
    end
}

