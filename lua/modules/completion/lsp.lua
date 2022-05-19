vim.cmd [[packadd nvim-lsp-installer]]
vim.cmd [[packadd lsp_signature.nvim]]
vim.cmd [[packadd lspsaga.nvim]]
vim.cmd [[packadd cmp-nvim-lsp]]
vim.cmd [[packadd aerial.nvim]]
vim.cmd [[packadd vim-illuminate]] 

local saga = require("lspsaga")
saga.init_lsp_saga({
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    code_action_prompt = {
        enable = false,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
})

local lsp_installer = require("nvim-lsp-installer")
local servers = {
    "bashls",
    "gopls",
    "jdtls",
    "jsonls",
    "lemminx",
    "pyright",
    "sqls",
    "sumneko_lua",
    "vimls",
}

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end

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
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function custom_attach(client, bufnr)
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
    require("aerial").on_attach(client, bufnr)
    require("illuminate").on_attach(client)
    -- Set underline highlighting for Lsp references
    vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
    vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
    vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")
end

local enhance_server_opts = {
    ["sumneko_lua"] = function(opts)
        opts.settings = {
            Lua = {
                diagnostics = {globals = {"vim", "packer_plugins", "hs"}},
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
    if server.name == "jdtls" then
        return
    end

    local opts = {
        capabilities = capabilities,
        flags = { debounce_text_changes = 500 },
        on_attach = custom_attach,
    }

    if enhance_server_opts[server.name] then
        enhance_server_opts[server.name](opts)
    end

    server:setup(opts)
end)

local M = {}

M.custom_attach = function(client, bufnr)
    return custom_attach(client, bufnr)
end

return M
