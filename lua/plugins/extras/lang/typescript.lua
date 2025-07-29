return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      vim.list_extend(opts.ensure_installed or {}, {
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
      })
    end,
  },

  -- Tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "eslint-lsp",
        "prettierd",
        "eslint_d",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    opts = {
      servers = {
        ts_ls = {
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
      },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        less = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        ["markdown.mdx"] = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" },
        handlebars = { "prettierd", "prettier" },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
      },
    },
  },

  -- Package info
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = { "json" },
    opts = {},
    keys = {
      { "<leader>ns", "<cmd>lua require('package-info').show()<cr>",           desc = "Show package info" },
      { "<leader>nc", "<cmd>lua require('package-info').hide()<cr>",           desc = "Hide package info" },
      { "<leader>nt", "<cmd>lua require('package-info').toggle()<cr>",         desc = "Toggle package info" },
      { "<leader>nu", "<cmd>lua require('package-info').update()<cr>",         desc = "Update package" },
      { "<leader>nd", "<cmd>lua require('package-info').delete()<cr>",         desc = "Delete package" },
      { "<leader>ni", "<cmd>lua require('package-info').install()<cr>",        desc = "Install package" },
      { "<leader>np", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change package version" },
    },
  },
}

