return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("user.config.lsp")
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      local null_ls = require "null-ls"
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      null_ls.setup {
        debug = false,
        -- You can then register sources by passing a sources list into your setup function:
        -- using `with()`, which modifies a subset of the source's default options
        sources = {
          formatting.prettier,
          formatting.stylua,
          formatting.markdownlint,
          formatting.beautysh.with { extra_args = { "--indent-size", "2" } },
          formatting.black,
          diagnostics.flake8.with {
            extra_args = { "--ignore=E203,E501,E402,F401,F821,W503,W292" },
            filetypes = { "python" },
          },
        },
      }
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "google_java_format",
        "black",
        "flake8",
        "markdownlint",
        "beautysh",
      },
      automatic_setup = true,
    },
  },

  "mfussenegger/nvim-jdtls",
}
