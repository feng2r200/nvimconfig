return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      vim.list_extend(opts.ensure_installed or {}, { "dockerfile" })
    end,
  },

  -- Tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "dockerfile-language-server",
        "hadolint",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
}