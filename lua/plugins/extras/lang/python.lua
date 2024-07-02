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
            python = {
              analysis = {
                typeCheckingMode = "off",
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
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
