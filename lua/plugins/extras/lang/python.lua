return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          root_dir = function()
            return require("plugins.extras.util").get_root()
          end,
          before_init = function(_, config)
            config.settings.python.pythonPath = require("plugins.extras.util").get_python_path(config.root_dir)
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                ignore = { "*" },
                -- indexing = true,
                -- typeCheckingMode = "basic",
                -- diagnosticMode = "workspace",
                -- autoImportCompletions = true,
                -- autoSearchPaths = true,
                -- inlayHints = {
                --   variableTypes = true,
                --   functionReturnTypes = true,
                -- },
                -- useLibraryCodeForTypes = true,
                -- diagnosticSeverityOverrides = {
                --   reportGeneralTypeIssues = "none",
                --   reportOptionalMemberAccess = "none",
                --   reportOptionalSubscript = "none",
                --   reportPrivateImportUsage = "none",
                -- },
              },
            },
          },
        },
        ruff_lsp = {
          root_dir = function()
            return require("plugins.extras.util").get_root()
          end,
          before_init = function(_, config)
            config.settings.python.pythonPath = require("plugins.extras.util").get_python_path(config.root_dir)
          end,
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
      },
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = function()
          local root_path = require("plugins.extras.util").get_root()
          local path = require("plugins.extras.util").get_python_path(root_path)
          return {
            runner = "pytest",
            python = path,
          }
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<F8>", "<cmd> lua require('dap').step_over()<cr>" },
        { "<F7>", "<cmd> lua require('dap').step_into()<cr>" },
        { "<F9>", "<cmd> lua require('dap').step_out()<cr>" },
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        local root_path = require("plugins.extras.util").get_root()
        local path = require("plugins.extras.util").get_python_path(root_path)
        require("dap-python").setup(path)
        require("dap-python").resolve_python = function()
          return path
        end
      end,
    },
  },
}
