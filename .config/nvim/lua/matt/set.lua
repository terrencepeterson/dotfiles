vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.report = 9999 -- stops vim messsaging saying "X fewer lines" when deleting chunks

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.guicursor = "n-v-c:block-blinkon530,i:ver25-blinkon530"
vim.opt.fillchars = { eob = ' ' }
vim.opt.splitright = true
vim.opt.splitbelow = false
-- vim.opt.statusline = "%{expand('%:.')}" -- make status line path relative
-- vim.opt.statusline = 0
vim.opt.laststatus = 0

vim.lsp.set_log_level("error")

vim.opt.guicursor = {
    "n-v-c:block-White/lCursor-blinkon100-blinkoff100",
    "i-ci:ver25-White/lCursor-blinkon100-blinkoff100",
    "r-cr:hor20-White/lCursor-blinkon100-blinkoff100",
    "o:hor50-White/lCursor-blinkon100-blinkoff100"
}

-- auto reloads the buffer if changes have been made externally
-- the checktime tells Neovim to check if any open buffers have been modified externally (by comparing file timestamps).
-- so withouh the above neovim may still not autoreload a changed buffer (as autoload only checks at specific moments)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    command = "checktime"
})

-- notify when the file is reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    callback = function()
        vim.notify("File atuo reloaded", vim.log.levels.INFO)
    end
})

vim.o.tabline = '%!v:lua.MyTabLine()'

function _G.MyTabLine()
    local s = ''
    for i = 1, vim.fn.tabpagenr('$') do
        if i == vim.fn.tabpagenr() then
            s = s .. '%#TabLineSel#'
        else
            s = s .. '%#TabLine#'
        end
        local buflist = vim.fn.tabpagebuflist(i)
        local winnr = vim.fn.tabpagewinnr(i)
        local bufname = vim.fn.bufname(buflist[winnr])

        local label
        if bufname:match('^fugitive://') then
            label = 'fugitive'
        elseif bufname:match('^oil://') then
            local path = bufname:gsub('^oil://', '')
            local parts = {}
            for part in path:gmatch('[^/]+') do
                table.insert(parts, part)
            end
            if #parts >= 5 then
                label = '.../' .. table.concat({ parts[#parts - 3], parts[#parts - 2], parts[#parts - 1], parts[#parts] },
                    '/')
            else
                label = path
            end
        else
            label = vim.fn.fnamemodify(bufname, ':t')
            if label == '' then label = '[No Name]' end
        end

        s = s .. ' ' .. label .. ' '
    end
    return s .. '%#TabLineFill#'
end
