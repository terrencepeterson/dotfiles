local builtin = require('telescope.builtin')
local telescope = require('telescope')
local utils = require('telescope.utils')
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local lga_actions = require('telescope-live-grep-args.actions')

local select_one_or_multi = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        actions.close(prompt_bufnr)
        for _, j in pairs(multi) do
            if j.path ~= nil then
                vim.cmd.tabedit(vim.fn.fnameescape(j.path))
            end
        end
    else
        actions.select_default(prompt_bufnr)
    end
end

-- Custom picker to open directory in Oil
function OpenFolderWithOil()
    builtin.find_files({
        prompt_title = "Find directory for Oil",
        find_command = { "fd", "--type", "d", "--hidden", "--no-ignore" },
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if entry and entry.path then
                    vim.cmd("Oil" .. vim.fn.fnameescape(entry.path) .. " --preview")
                end
            end)
            return true
        end,
    })
end

vim.keymap.set("n", "<leader>pd", OpenFolderWithOil, { desc = "Find folder and open in Oil" })

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({
        no_ignore = true
    })
end, { desc = 'Telescope find all files' })

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end

vim.keymap.set('v', '<leader>pf', function()
    local text = vim.getVisualSelection()
    builtin.find_files({
        no_ignore = true,
        default_text = text
    })
end, { desc = 'Telescope find all files' })

vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files respects .gitignore' })

-- opens recent files and goes to normal mode so can scroll straight away with jk keys
vim.keymap.set('n', '<leader>pr', function()
    builtin.oldfiles({
        prompt_title = "Recent files",
        cwd_only = true,
        attach_mappings = function(_, map)
            -- Immediately switch to normal mode when the picker opens
            vim.schedule(function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', false)
            end)
            return true
        end,
    })
end, { desc = "Recent files in project (normal mode)" })

vim.keymap.set("v", "<leader>ps", function()
    require("telescope-live-grep-args.shortcuts").grep_visual_selection()
end, { desc = "Live Grep Args (Find Selected Text)" })

vim.keymap.set("n", "<leader>ps", function()
    telescope.extensions.live_grep_args.live_grep_args()
end)

vim.keymap.set('n', '<leader>ds', function()
    telescope.extensions.live_grep_args.live_grep_args({
        search_dirs = { utils.buffer_dir():gsub("oil://", "") }
    })
end, { desc = 'Telescope search in current dir' })

vim.keymap.set('n', '<leader>df', function()
    local dir = vim.fn.expand("%:p:h")
    dir = dir:gsub("^oil://", "") -- strip Oil prefix

    require("telescope.builtin").find_files({
        cwd = dir,
        no_ignore = true,
    })
end, { desc = 'Telescope find files in current dir' })

vim.keymap.set('n', '<leader>pi', function()
    builtin.lsp_implementations()
end)

-- resume last used picker
vim.keymap.set("n", "<leader>tr", function ()
    builtin.resume({
        attach_mappings = function(_, map)
            -- Immediately switch to normal mode when the picker opens
            vim.schedule(function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', false)
            end)
            return true
        end,
    })
end)

local grep_no_ignore = function(prompt_bufnr)
    lga_actions.quote_prompt({ postfix = ' --no-ignore -F ' })(prompt_bufnr)
end

telescope.setup({
    defaults = {
        path_display = { filename_first = { reverse_directories = false } },
        wrap_results = true,
        layout_strategy = "vertical",
        layout_config = {
            width = 0.99,
            height = 0.97,
        },
        history = {
            path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
            limit = 100,
        },
        mappings = {
            i = {
                ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
                ['<C-t>'] = select_one_or_multi,
            },
            n = {
                ['<C-t>'] = select_one_or_multi,
                ['q'] = actions.close
            }
        }
    },
    extensions = {
        live_grep_args = {
            layout_strategy = "flex",
            layout_config = {
                horizontal = {
                    preview_width = 0.35,
                },
            },
            entry_maker = function(line)
                local make_entry = require('telescope.make_entry').gen_from_vimgrep()
                local e = make_entry(line)

                local original_display = e.display

                e.display = function(entry)
                    local display, highlights = original_display(entry)

                    -- Only keep the filename + line/col, remove the text
                    -- highlights is a table like { {start, end, hl_group}, ... }
                    local text_start = display:find(entry.text, 1, true)
                    if text_start then
                        display = display:sub(1, text_start - 1)
                        -- Remove any highlights beyond this point
                        for i = #highlights, 1, -1 do
                            local hl = highlights[i]
                            if hl[1][1] >= text_start then
                                table.remove(highlights, i)
                            end
                        end
                    end

                    return display, highlights
                end

                return e
            end,
            mappings = { -- extend mappings
                i = {
                    ["<C-i>"] = grep_no_ignore,
                    ['<C-t>'] = select_one_or_multi
                },
                n = {
                    ["<C-i>"] = grep_no_ignore,
                    ['<C-t>'] = select_one_or_multi
                }
            },
        }
    }
})

telescope.load_extension("live_grep_args")
telescope.load_extension("smart_history")
