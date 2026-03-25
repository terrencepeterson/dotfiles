-- stops the bug where when you enter visual mode it removes the BS (backspace) mapping
vim.g.VM_maps = {
    ["I BS"] = '', -- Don't map BS in VM insert mode
}
