vim.cmd [[packadd nvim-lsp-installer]]
vim.cmd [[packadd lsp_signature.nvim]]
vim.cmd [[packadd lspsaga.nvim]]
vim.cmd [[packadd cmp-nvim-lsp]]

local lsp_installer = require("nvim-lsp-installer")
local nvim_lsp_util = require("lspconfig/util")

require("lspsaga").init_lsp_saga {
    error_sign = '',
    warn_sign = '',
    hint_sign = '',
    infor_sign = ''
}

lsp_installer.settings {
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local function custom_attach(client)
    require("lsp_signature").on_attach({
        bind = true,
        use_lspsaga = false,
        floating_window = true,
        floating_window_above_cur_line = true,
        fix_pos = true,
        hint_enable = true,
        hi_parameter = "Search",
        handler_opts = {"double"},
        always_trigger = false,
        zindex = 50,
        transpancy = 20
    })
end

local enhance_server_opts = {
    ["sumneko_lua"] = function(opts)
        opts.settings = {
            Lua = {
                diagnostics = {globals = {"vim", "hs"}},
                workspace = {
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                        ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000
                },
                telemetry = {enable = false}
            }
        }
    end,
    ["jsonls"] = function(opts)
        opts.settings = {
            json = {
                -- Schemas https://www.schemastore.org
                schemas = {
                    {
                        fileMatch = {"package.json"},
                        url = "https://json.schemastore.org/package.json"
                    }, {
                        fileMatch = {"tsconfig*.json"},
                        url = "https://json.schemastore.org/tsconfig.json"
                    }, {
                        fileMatch = {
                            ".prettierrc", ".prettierrc.json",
                            "prettier.config.json"
                        },
                        url = "https://json.schemastore.org/prettierrc.json"
                    }, {
                        fileMatch = {".eslintrc", ".eslintrc.json"},
                        url = "https://json.schemastore.org/eslintrc.json"
                    }, {
                        fileMatch = {
                            ".babelrc", ".babelrc.json", "babel.config.json"
                        },
                        url = "https://json.schemastore.org/babelrc.json"
                    },
                    {
                        fileMatch = {"lerna.json"},
                        url = "https://json.schemastore.org/lerna.json"
                    }, {
                        fileMatch = {
                            ".stylelintrc", ".stylelintrc.json",
                            "stylelint.config.json"
                        },
                        url = "http://json.schemastore.org/stylelintrc.json"
                    }, {
                        fileMatch = {"/.github/workflows/*"},
                        url = "https://json.schemastore.org/github-workflow.json"
                    }
                }
            }
        }
    end,
    ["gopls"] = function(opts)
        opts.settings = {
            gopls = {
                usePlaceholders = true,
                analyses = {
                    nilness = true,
                    shadow = true,
                    unusedparams = true,
                    unusewrites = true
                }
            }
        }
    end,
    ["sqls"] = function(opts)
        opts.cmd = { "sqls", "-config", os.getenv("HOME") .. "/.config/sqls/config.yml" }
    end,
}

lsp_installer.on_server_ready(function(server)
    local opts = {
        capabilities = capabilities,
        flags = { debounce_text_changes = 500 },
        on_attach = custom_attach,
    }

    if enhance_server_opts[server.name] then
        enhance_server_opts[server.name](opts)
    end

    if server.name == "rust_analyzer" then
        require("rust_tools").setup({
            server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
        })
        server:attach_buffers()
    else
        server:setup(opts)
    end
end)

