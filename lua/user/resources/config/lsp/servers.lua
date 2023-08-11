local servers = {
  rust_analyzer = {
    disabled = true,
    opts = function(capabilities)
      local install_root_dir = vim.fn.stdpath "data" .. "/mason"
      local extension_path = install_root_dir .. "packages/codelldb/extension"
      local codelldb_path = extension_path .. "/adapter/codelldb"
      local liblldb_path = extension_path .. "/lldb/lib/liblldb.dylib"

      return {
        tools = {
          autoSetHints = true,
          executor = require("rust-tools/executors").termopen,

          on_initialized = function()
            --[[ vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, { ]]
            --[[   pattern = { "*.rs" }, ]]
            --[[   callback = function() ]]
            --[[     vim.lsp.codelens.refresh() ]]
            --[[   end, ]]
            --[[ }) ]]
          end,

          runnables = {
            use_telescope = true,
          },

          debuggables = {
            use_telescope = true,
          },

          inlay_hints = {
            auto = false,
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            show_variable_name = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = " => ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },

          hover_actions = {
            auto_focus = true,
            border = "rounded",
            width = 60,
          },
        },

        server = {
          standalone = false,
          -- on_attach = lsp_handlers.on_attach,
          capabilities = capabilities,

          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                autoReload = true,
              },
              lens = {
                enable = true,
              },
            },
          },
        },

        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {
    init_options = {
      provideFormatter = false,
    },
    settings = {
      json = {
        schemas = function()
          return require("schemastore").json.schemas()
        end,
      },
    },
    setup = {
      commands = {},
    },
  },
  sqlls = {},
  intelephense = {}, -- php language server
  jdtls = {
    disabled = true,
  },
  sumneko_lua = {
    settings = {
      Lua = {
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            continuation_indent_size = "2",
          },
        },
        filetypes = { "lua" },
        runtime = {
          version = "LuaJIT",
          special = {
            reload = "require",
          },
        },
        diagnostics = {
          enable = true,
          globals = { "vim", "packer_plugins", "hs", "describe" },
        },
        completion = {
          enable = true,
          callSnippet = "Replace",
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "config" .. "/lua"] = true,
            ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
          checkThirdParty = false,
        },

        hint = {
          enable = true,
          arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
          await = true,
          paramName = "Disable", -- "All", "Literal", "Disable"
          paramType = false,
          semicolon = "Disable", -- "All", "SameLine", "Disable"
          setType = true,
        },
        telemetry = { enable = false },
        misc = {
          parameters = {
            "--log-level=trace",
          },
        },
      },
    },
  },
  tsserver = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  pyright = {
    root_dir = function()
      return vim.fs.dirname(vim.fs.find({ ".git", ".env" }, { upward = true })[1])
    end,
    before_init = function(_, config)
      config.settings.python.pythonPath = require("user.util").get_python_path(config.root_dir)
    end,
    settings = {
      python = {
        analysis = {
          indexing = true,
          typeCheckingMode = "basic",
          diagnosticMode = "workspace",
          autoImportCompletions = true,
          autoSearchPaths = true,
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
          },
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = "none",
            reportOptionalMemberAccess = "none",
            reportOptionalSubscript = "none",
            reportPrivateImportUsage = "none",
          },
        },
      },
    },
  },

  gopls = {
    settings = {
      gopls = {
        usePlaceholders = true,
        analyses = {
          nilness = true,
          shadow = true,
          unusedparams = true,
          unusewrites = true,
        },
      },
    },
  },
}
return servers
