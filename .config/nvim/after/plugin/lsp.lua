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
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
    on_attach = function(client, bufnr)
        if not base_on_attach then return end

        base_on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
        })
    end,
})
vim.lsp.enable('eslint')

local vue_plugin = {
    name = '@vue/typescript-plugin',
    languages = { 'vue' },
    configNamespace = 'typescript',
}
vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})
vim.lsp.enable('vue_ls')
vim.lsp.enable('vtsls')
-- vim.lsp.config('vue_ls', {
--     -- add filetypes for typescript, javascript and vue
--     filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
--     init_options = {
--         vue = {
--             -- disable hybrid mode
--             hybridMode = false,
--         },
--         typescript = {
--             -- replace with your global TypeScript library path
--             tsdk = '/home/matt/.nvm/versions/node/v22.16.0/lib/node_modules/typescript/lib'
--         }
--     },
-- })
-- vim.lsp.enable('vue_ls')
--
-- ### OLD VUE SETUP LEAVING HERE JUST IN CASE ###
-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers.
-- local handle = io.popen("npm list -g --parseable | grep @vue/language-server")
-- local result = handle:read("*a")
-- handle:close()
-- local vue_language_server_path = result:match("^%s*(.-)%s*$")

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

vim.lsp.enable('cssls')

vim.lsp.config('tailwindcss', {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = false -- when this is enabled it registers tonnes of inotify watchers!
            }
        },
    },
    on_init = function(client)
        -- set the config path explicitly, if not the lsp searches for it in other direcotries and throws a hissy fit
        local tailwindRelativePath = vim.fn.system("fd tailwind.config.js"):match("^%s*(.-)%s*$")
        if tailwindRelativePath ~= "" then
            local projectRoot = client.workspace_folders[1].name
            local tailwindAbsolutePath = projectRoot .. "/" .. tailwindRelativePath
            client.config.settings.tailwindCSS.experimental.configFile = tailwindAbsolutePath
        end
    end,
    settings = {
         tailwindCSS = {
            experimental = {
                configFile = ""
            }
         }
    },
    filetypes = { -- phtml doesn't work here we must listen for php
        "html", "vue", "css", "scss", "php", "blade"
    },
})
vim.lsp.enable('tailwindcss')


vim.lsp.config('phpactor', {
    init_options = {
        ["indexer.exclude_patterns"] = {
            "**/vendor/**",
            "**/node_modules/**",
            "**/pub/static/**",
            "**/var/**",
            "**/generated/**",
            "**/magento/dev/**"
        },
    },
})
vim.lsp.enable('phpactor')

vim.lsp.enable('bashls')

vim.lsp.enable('twiggy_language_server')
vim.lsp.config('html', {
    filetypes = { "html", "php", "phtml" },
    init_options = {
        provideFormatter = true,
        embeddedLanguages = {
            css = true,
            javascript = true
        },
    }
})
vim.lsp.enable('html')

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library'
                    -- '${3rd}/busted/library'
                }
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = {
                --   vim.api.nvim_get_runtime_file('', true),
                -- }
            }
        })
    end,
    settings = {
        Lua = {}
    }
})
vim.lsp.enable('lua_ls')

vim.lsp.enable('jsonls')

vim.lsp.enable('docker_compose_language_service')

vim.lsp.enable('laravel_ls')
