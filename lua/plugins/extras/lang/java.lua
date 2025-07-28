return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      vim.list_extend(opts.ensure_installed or {}, { "java" })
    end,
  },

  -- Tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    ft = { "java" },
    opts = {
      servers = {
        jdtls = {
          -- Eclipse JDTLS configuration will be handled by nvim-jdtls
        },
      },
      setup = {
        jdtls = function()
          return true -- avoid duplicate setup
        end,
      },
    },
  },

  -- Enhanced Java support
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    opts = function()
      return {
        -- Path to jar file
        cmd = {
          vim.fn.exepath("jdtls"),
        },
        root_dir = function(fname)
          return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
        end,
      }
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("jdtls").start_or_attach(opts)
        end,
      })
    end,
  },

  -- Debug Adapter
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mfussenegger/nvim-jdtls",
      },
    },
  },
}