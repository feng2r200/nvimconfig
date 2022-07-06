local status_ok, rust_tools = pcall(require, "rust-tools")
if not status_ok then
  return
end

local liblldb_path   = "/usr/local/opt/llvm/bin/lldb-vscode"

vim.cmd([[packadd nvim-lspconfig]])

local lsp_handlers = require "lsp.handlers"

local opts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    executor = require("rust-tools/executors").termopen,

    on_initialized = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
        pattern = { "*.rs" },
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end,

    runnables = {
      use_telescope = true,
    },

    debuggables = {
      use_telescope = true,
    },

    inlay_hints = {
      only_current_line = false,
      only_current_line_autocmd = "CursorHold",
      show_parameter_hints = true,
      show_variable_name = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = " » ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
      highlight = "Comment",
    },

    hover_actions = {
      auto_focus = false,
      border = "rounded",
      width = 60,
    },

    crate_graph = {
      backend = "x11",
      output = nil,
      pipe = nil,
      full = true,
    }
  },

  server = {
    standalone = false,
    on_attach = lsp_handlers.on_attach,
    capabilities = lsp_handlers.capabilities,

    settings = {
      ["rust-analyzer"] = {
        lens = {
          enable = true,
        },
      },
    },
  },

  dap = {
    adapter = {
      type = "executable",
      command = liblldb_path,
      name = "lldb",
    }
  },
}

rust_tools.setup(opts)

local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    L = {
      name = "Rust",
      r = { "<cmd>RustRunnables<Cr>", "Runnables" },
      m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
      c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
      p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
      d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
      v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
      R = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "Reload Workspace",
      },
    },
  }

  wk.register(mappings, {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  })
end

local notify_filter = vim.notify
vim.notify = function(msg, ...)
  if msg:match "message with no corresponding" then
    return
  end

  notify_filter(msg, ...)
end

