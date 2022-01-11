if not packer_plugins["nvim-lsp-installer"].loaded then
    vim.cmd [[packadd nvim-lsp-installer]]
end

if not packer_plugins["lsp_signature.nvim"].loaded then
    vim.cmd [[packadd lsp_signature.nvim]]
end

if not packer_plugins["lspsaga.nvim"].loaded then
    vim.cmd [[packadd lspsaga.nvim]]
end

local lsp_installer = require("nvim-lsp-installer")

-- vim.lsp.set_log_level("info")

lsp_installer.settings {
    -- log_level = vim.log.levels.DEBUG,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.documentationFormat = {"markdown", "plaintext"}
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = {valueSet = {1}}
capabilities.textDocument.completion.completionItem.resolveSupport = {properties = {"documentation", "detail", "additionalTextEdits"}}

local function custom_attach()
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
}

lsp_installer.on_server_ready(function(server)
    local opts = {
        capabilities = capabilities,
        flags = {debounce_text_changes = 500},
        on_attach = custom_attach,
    }

    if enhance_server_opts[server.name] then
        enhance_server_opts[server.name](opts)
    end

    server:setup(opts)
end)

