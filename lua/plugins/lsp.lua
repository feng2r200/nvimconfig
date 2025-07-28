return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    opts = function()
      local keys = {
        { "<leader>cl", false },
        { "<c-k>", false, mode = "i" },
        { "<leader>cli", vim.lsp.buf.incoming_calls, desc = "Incoming calls" },
        { "<leader>clo", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls" },
      }
      
      return {
        -- LSP Server settings
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
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
    end,
    config = function(_, opts)
      -- Setup LSP configuration
      local lspconfig = require("lspconfig")
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )

      -- Setup key mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local buffer = ev.buf
          
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
          end

          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")
          map("n", "<space>D", vim.lsp.buf.type_definition, "Type definition")
          map("n", "<space>rn", vim.lsp.buf.rename, "Rename")
          map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "gr", vim.lsp.buf.references, "References")

          -- Format on save if the client supports it
          if client and client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = buffer,
              callback = function()
                vim.lsp.buf.format({ bufnr = buffer })
              end,
            })
          end
        end,
      })

      -- Setup servers
      for server, server_opts in pairs(opts.servers) do
        if server_opts.enabled ~= false then
          server_opts = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
          }, server_opts or {})
          
          if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
              return
            end
          end
          lspconfig[server].setup(server_opts)
        end
      end
    end,
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
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },
}

