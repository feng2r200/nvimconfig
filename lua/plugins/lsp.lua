return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- LSP Server settings
        servers = {},
        -- Global capabilities
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                documentationFormat = { "markdown", "plaintext" },
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                deprecatedSupport = true,
                commitCharactersSupport = true,
                tagSupport = { valueSet = { 1 } },
                resolveSupport = {
                  properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                  },
                },
              },
            },
          },
        },
        -- Setup handlers
        setup = {},
      }
      return ret
    end,
    config = function(_, opts)
      -- Setup LSP configuration
      local Util = require("util.lsp")
      
      -- Setup key mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          Util.on_attach(ev.data.client_id, ev.buf)
        end,
      })

      -- Setup capabilities
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )

      -- Function to setup servers
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, opts.servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- Setup servers when they're needed
      local mason_lspconfig = require("mason-lspconfig")
      local all_mslp_servers = {}
      
      -- Safely get server mappings
      local ok, mappings = pcall(require, "mason-lspconfig.mappings.server")
      if ok and mappings.lspconfig_to_package then
        all_mslp_servers = vim.tbl_keys(mappings.lspconfig_to_package)
      end

      local ensure_installed = {}
      
      for server, server_opts in pairs(opts.servers) do
        if server_opts.enabled ~= false then
          setup(server)
          if server_opts.mason ~= false and vim.tbl_contains(all_mslp_servers, server) then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
        handlers = { setup },
      })
    end,
  },

  -- Create LSP utility module
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    config = false,
    dependencies = { "nvim-lspconfig" },
  },

  -- Mason package manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Mason LSP configuration
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },
}

