require("modules.completion.formatting")

if not packer_plugins["nvim-lsp-installer"].loaded then
    vim.cmd [[packadd nvim-lsp-installer]]
end

if not packer_plugins["lsp_signature.nvim"].loaded then
    vim.cmd [[packadd lsp_signature.nvim]]
end

if not packer_plugins["lspsaga.nvim"].loaded then
    vim.cmd [[packadd lspsaga.nvim]]
end

if not packer_plugins["cmp-nvim-lsp"].loaded then
    vim.cmd [[packadd cmp-nvim-lsp]]
end

local lsp_installer = require("nvim-lsp-installer")

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

-- Override default format setting

vim.lsp.handlers["textDocument/formatting"] =
    function(err, result, ctx)
        if err ~= nil or result == nil then return end
        if vim.api.nvim_buf_get_var(ctx.bufnr, "init_changedtick") ==
            vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick") then
            local view = vim.fn.winsaveview()
            vim.lsp.util.apply_text_edits(result, ctx.bufnr)
            vim.fn.winrestview(view)
            if ctx.bufnr == vim.api.nvim_get_current_buf() then
                vim.b.saving_format = true
                vim.cmd [[update]]
                vim.b.saving_format = false
            end
        end
    end

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

    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua require'modules.completion.formatting'.format()]]
        vim.cmd [[augroup END]]
    end
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
    ["tsserver"] = function(opts)
        -- Disable `tsserver`'s format
        opts.on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            custom_attach(client)
        end
    end,
    ["dockerls"] = function(opts)
        -- Disable `dockerls`'s format
        opts.on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            custom_attach(client)
        end
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
        -- Disable `gopls`'s format
        opts.on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            custom_attach(client)
        end
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

local efmls = require("efmls-configs")

-- Init `efm-langserver` here.

efmls.init {
    on_attach = custom_attach,
    capabilities = capabilities,
    init_options = {documentFormatting = true, codeAction = true}
}

-- Require `efmls-configs-nvim`'s config here

local vint = require("efmls-configs.linters.vint")
local clangtidy = require("efmls-configs.linters.clang_tidy")
local eslint = require("efmls-configs.linters.eslint")
local flake8 = require("efmls-configs.linters.flake8")
local shellcheck = require("efmls-configs.linters.shellcheck")
local staticcheck = require("efmls-configs.linters.staticcheck")

local black = require("efmls-configs.formatters.black")
local luafmt = require("efmls-configs.formatters.lua_format")
local clangfmt = require("efmls-configs.formatters.clang_format")
local goimports = require("efmls-configs.formatters.goimports")
local prettier = require("efmls-configs.formatters.prettier")
local shfmt = require("efmls-configs.formatters.shfmt")

-- Add your own config for formatter and linter here

-- local rustfmt = require("modules.completion.efm.formatters.rustfmt")

-- Override default config here

flake8 = vim.tbl_extend('force', flake8, {
    prefix = "flake8: max-line-length=160, ignore F403 and F405",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
    lintCommand = "flake8 --max-line-length 160 --extend-ignore F403,F405 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -"
})

-- Setup formatter and linter for efmls here

efmls.setup {
    vim = {formatter = vint},
    lua = {formatter = luafmt},
    c = {formatter = clangfmt, linter = clangtidy},
    cpp = {formatter = clangfmt, linter = clangtidy},
    go = {formatter = goimports, linter = staticcheck},
    python = {formatter = black, linter = flake8},
    vue = {formatter = prettier},
    typescript = {formatter = prettier, linter = eslint},
    javascript = {formatter = prettier, linter = eslint},
    typescriptreact = {formatter = prettier, linter = eslint},
    javascriptreact = {formatter = prettier, linter = eslint},
    yaml = {formatter = prettier},
    html = {formatter = prettier},
    css = {formatter = prettier},
    scss = {formatter = prettier},
    sh = {formatter = shfmt, linter = shellcheck},
    markdown = {formatter = prettier}
    -- rust = {formatter = rustfmt},
}
