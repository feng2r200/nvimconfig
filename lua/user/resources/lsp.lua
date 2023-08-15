return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "onsails/lspkind-nvim",
    },
    keys = {
      { "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature help", },
      { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Previous diagnostic", },
      { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next diagnostic", },
      { "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Hover diagnostics", },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "LSP code action", },
      { "<leader>la", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", mode = "v", desc = "LSP code action", },
      {
        "<leader>lf",
        function()
          local bfn = vim.api.nvim_get_current_buf()
          vim.lsp.buf.format {
            bufnr = bfn,
            filter = function(c)
              return require("user.core.lsp").filter_format_lsp_client(c, bfn)
            end,
          }
        end,
        desc = "Format code",
      },
      { "<leader>lf", "<cmd>lua require('user.core.lsp').format_range_operator()<cr>", mode = "v", desc = "Format code", },
      { "<leader>li", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", desc = "Incoming Calls", },
      { "<leader>lo", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", desc = "Outgoing Calls", },
      { "<leader>lr", "<cmd>lua vim.lsp.codelens.refresh()<cr>", desc = "Refresh Codelens" },
      { "<leader>lR", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "Run Codelens" },
      { "K", "<cmd>lua require('user.core.lsp').code_hover()<cr>", desc = "Code hover", },
      { "R", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", },
    },
    config = function()
      require "user.resources.config.lsp"
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup {
        ui = {
          keymaps = {
            apply_language_filter = "f",
          },
        },
      }
    end,
  },

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
          formatting.markdownlint,
          formatting.beautysh.with { extra_args = { "--indent-size", "2" } },
          formatting.black.with { extra_args = { "--fast" } },
          formatting.tidy.with {
            extra_args = { "-xml", "-i" },
          },
          formatting.sqlfluff.with {
            extra_args = { "--dialect", "mysql", "--FIX-EVEN-UNPARSABLE" },
          },
          formatting.stylua.with {
            extra_args = { "--config-path", vim.fn.expand(vim.fn.stdpath "config" .. "/.stylua.toml") },
          },
          formatting.jq,
          formatting.gofmt,
          formatting.taplo,
          formatting.rustfmt.with {
            extra_args = function(params)
              local Path = require "plenary.path"
              local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

              if cargo_toml:exists() and cargo_toml:is_file() then
                for _, line in ipairs(cargo_toml:readlines()) do
                  local edition = line:match [[^edition%s*=%s*%"(%d+)%"]]
                  if edition then
                    return { "--edition=" .. edition }
                  end
                end
              end
              -- default edition when we don't find `Cargo.toml` or the `edition` in it.
              return { "--edition=2021" }
            end,
          },

          diagnostics.flake8.with {
            extra_args = { "--ignore=E203,E501,E402,F401,F821,W503,W292" },
            filetypes = { "python" },
          },
          diagnostics.jsonlint,
          diagnostics.sqlfluff.with {
            extra_args = {
              "--ignore-local-config",
              "--dialect",
              "mysql",
              "--exclude-rules",
              "L001,L003,L004,L006,L009,L010,L011,L016,L029,L031,L036,L059",
            },
          },
          diagnostics.tidy,
        },
      }
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    dependencies = "nvim-lspconfig",
    config = function(_, opts)
      require("fidget").setup(opts)
    end,
  },
}
