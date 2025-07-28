return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      vim.list_extend(opts.ensure_installed or {}, {
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "helm",
      })

      -- Convert a JSON string to a Go struct.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          vim.api.nvim_buf_create_user_command(
            0,
            "JsonToStruct",
            function(args)
              local range = args.line1 .. "," .. args.line2
              local fname = vim.api.nvim_buf_get_name(0)
              local cmd = { "!json-to-struct" }
              table.insert(cmd, "-name " .. vim.fn.fnamemodify(fname, ":t:r"))
              table.insert(cmd, "-pkg " .. vim.fn.fnamemodify(fname, ":h:t:r"))
              vim.cmd(range .. " " .. table.concat(cmd, " "))
            end,
            { bar = true, nargs = 0, range = true }
          )
        end,
      })
    end,
  },

  -- Tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "gopls",
        -- Formatters
        "gofumpt",
        "goimports-reviser",
        -- Tools
        "gomodifytags",
        "impl",
        "json-to-struct",
        -- Debugger
        "delve",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              experimentalPostfixCompletions = true,
              analyses = {
                unusedparams = true,
                shadow = true,
                fieldalignment = false,
                unusedvariable = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
          init_options = {
            usePlaceholders = true,
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- Workaround for gopls not supporting semanticTokensProvider
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "gopls" then
                if not client.server_capabilities.semanticTokensProvider then
                  local semantic = client.config.capabilities.textDocument.semanticTokens
                  if semantic then
                    client.server_capabilities.semanticTokensProvider = {
                      full = true,
                      legend = {
                        tokenTypes = semantic.tokenTypes,
                        tokenModifiers = semantic.tokenModifiers,
                      },
                      range = true,
                    }
                  end
                end
              end
            end,
          })
        end,
      },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },

  -- Debug Adapter
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
  },

  -- Testing
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          dap_go_enabled = true,
        },
      },
    },
  },
}
