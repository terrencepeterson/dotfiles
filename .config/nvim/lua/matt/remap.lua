vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set({ "n", "v" }, "<leader>d", [["+d]])

-- This is going to get me cancelled
-- vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )

-- vim.keymap.set(
--     "n",
--     "<leader>ea",
--     "oassert.NoError(err, \"\")<Esc>F\";a"
-- )
--
-- vim.keymap.set(
--     "n",
--     "<leader>ef",
--     "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
-- )
--
-- vim.keymap.set(
--     "n",
--     "<leader>el",
--     "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
-- )

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- my custom mappings
-- save and close
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "QuitPre" }, {
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.api.nvim_command('silent update')
        end
    end,
})

function vim.tbl_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            -- vim.notify(value, vim.log.levels.INFO)
            return true
        end
    end
    return false
end

local hideWinBarFileTypes = { 'git', 'fugitive', 'undotree' }
local function shouldShowWinBar()
    local win = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win)
    -- if it's not a normal window: fixes telescope breaking running out of memory
    if win_config.relative ~= "" then return end

    local buf = vim.api.nvim_win_get_buf(win)
    -- need to explictly get file type here, if not doesn't work with tabs
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    return not vim.tbl_contains(hideWinBarFileTypes, filetype)
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        vim.wo.winbar = shouldShowWinBar() and "%{%v:lua.GetWinBar()%}" or ""
        -- cleanPath = filename == cleanPath and "" or cleanPath -- stops file path from showing twice when editing files at project level
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
        vim.wo.winbar = ""
    end,
})

-- only hide the status bar when you're in kitty
-- we use alacritty as i had trouble passing through env vars
-- from kitty conf into tmux but alacritty just works
local function isTerminalAlacritty()
    return os.getenv('TERM_EMULATOR') == 'alacritty'
end

vim.keymap.set("n", "<leader>z", function()
    print(isTerminalAlacritty())
end)

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        -- vim.fn.system('tmux set status off')
        if not isTerminalAlacritty() then
            vim.fn.system('tmux set status off')
        end
    end
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    callback = function()
        -- vim.fn.system('tmux set status on')
        if not isTerminalAlacritty() then
            vim.fn.system('tmux set status on')
        end
    end
})

vim.keymap.set("n", "q", vim.cmd.q)
vim.keymap.set("n", "<leader>w", vim.cmd.w)

vim.keymap.set("n", "<leader>ya", function()
    local dir = vim.fn.expand("%:p")
    local cleanDir = dir:gsub("oil://", "")
    vim.fn.setreg("+", cleanDir)
    vim.notify("Yanked absolute filepath", vim.log.levels.INFO)
end, { desc = "Copy absolute file path to clipboard" })

vim.keymap.set("n", "<leader>yf", function()
    vim.fn.setreg("+", vim.fn.expand("%:t"))
    vim.notify("Yanked filename", vim.log.levels.INFO)
end, { desc = "Copy the file name to clipboard" })

vim.keymap.set("n", "<leader>yr", function()
    local dir = vim.fn.expand("%")
    local cleanDir = dir:gsub("oil://", "")
    vim.fn.setreg("+", cleanDir)
    vim.notify("Yanked relative file path", vim.log.levels.INFO)
end, { desc = "Copu the relative file path to clipboard" })

vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Run Gdiffsplit" })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        if vim.v.operator == "y" and vim.fn.mode() ~= "v" and vim.fn.mode() ~= "V" then
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
        end
    end
})

vim.keymap.set("n", "<leader>td", "<cmd>lua vim.lsp.buf.definition()<CR>",
    { noremap = true, silent = true, desc = "Go to definition" })

vim.keymap.set("n", "<leader>c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

vim.keymap.set('n', '<leader>sf', function()
    local word = vim.fn.expand("<cword>")    -- Get word under cursor
    vim.cmd("normal! /" .. word .. "\\<CR>") -- Search for it
end, { desc = "Search current word in file", silent = true })

vim.keymap.set('v', '<leader>z', function()
    vim.cmd('normal! "zy')                         -- Yank selection into register z
    vim.cmd('execute "normal! /" . @z . "\\<CR>"') -- Search using register z
end)

vim.keymap.set("n", "<CR>", ":noh<CR>", { noremap = true, silent = true })

-- opens file explorer in current directory
vim.keymap.set('n', '<leader>e', function()
    local dir = vim.fn.expand("%:p:h")
    local cleanDir = dir:gsub("oil://", "")
    vim.fn.jobstart({ "xdg-open", cleanDir }, { detach = true })
end)

vim.keymap.set('n', '<leader>m', function()
    local line_length = vim.fn.virtcol('$')     -- get the virtual column of end of line
    local mid_col = math.floor(line_length / 2) -- calculate middle column
    vim.cmd("normal! 0" .. mid_col .. "|")      -- jump to middle column
end)

-- remove all whitespace
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function getPhpNamespace()
    local file_path = vim.fn.expand("%:p")
    return trim(vim.fn.system(string.format("phpactor file:info %s | grep '^class:' | sed 's/class://g'", file_path)))
end

vim.keymap.set('n', '<leader>yc', function()
    local namespace = getPhpNamespace()
    local className = string.gsub(namespace, "\\", "/")
    if className == "" then
        vim.notify("Failed to yank php class", vim.log.levels.ERROR)
        return
    end
    vim.fn.setreg("+", className)
    vim.fn.setreg('"', className)
    vim.notify("Yanked PHP class", vim.log.levels.INFO)
end)

vim.keymap.set('n', '<leader>yn', function()
    local namespace = getPhpNamespace()
    if namespace == "" then
        vim.notify("Failed to yank php namespace", vim.log.levels.ERROR)
        return
    end
    vim.fn.setreg("+", namespace)
    vim.fn.setreg('"', namespace)
    vim.notify("Yanked PHP namespace", vim.log.levels.INFO)
end)

vim.keymap.set("n", "<tab>", function()
    local isTabs = #vim.api.nvim_list_tabpages() > 1
    if not isTabs then
        vim.cmd('wincmd w')
    else
        vim.cmd('tabnext')
    end
end)
