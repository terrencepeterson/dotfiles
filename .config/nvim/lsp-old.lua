-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers.
local handle = io.popen("npm list -g --parseable | grep @vue/language-server")
local result = handle:read("*a")
handle:close()
local vue_language_server_path = result:match("^%s*(.-)%s*$")

require('lspconfig').eslint.setup({
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end,
})

vim.lsp.config('vue_ls', {
    -- add filetypes for typescript, javascript and vue
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        init_options = {
        vue = {
            -- disable hybrid mode
            hybridMode = false,
        },
        typescript = {
            -- replace with your global TypeScript library path
            tsdk = '/home/matt/.nvm/versions/node/v22.16.0/lib/node_modules/typescript/lib'
        }
    },
})
vim.lsp.enable('vue_ls')
-- require('lspconfig').ts_ls.setup({
--     init_options = {
--         plugins = {
--             {
--                 name = '@vue/typescript-plugin',
--                 location = vue_language_server_path,
--                 languages = { 'vue' },
--             },
--         },
--     },
--     filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
-- })
-- vim.lsp.config('ts_ls', {
--     init_options = {
--         plugins = {
--             {
--                 name = '@vue/typescript-plugin',
--                 location = vue_language_server_path,
--                 languages = { 'vue' },
--             },
--         },
--     },
--     filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
-- })

require('lspconfig').cssls.setup({})

require('lspconfig').tailwindcss.setup({})

require('lspconfig').phpactor.setup({})

require('lspconfig').bashls.setup({})

require('lspconfig').html.setup({
    filetypes = { "html", "php", "phtml" },
    init_options = {
        provideFormatter = true,
        embeddedLanguages = {
            css = true,
            javascript = true
        },
    }
})

vim.lsp.enable('twiggy_language_server')

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

