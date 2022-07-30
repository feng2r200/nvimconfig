local lsp_handlers = require "configs.lsp.handlers"

return {
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
      auto_focus = true,
      border = "rounded",
      width = 60,
    },
  },

  server = {
    standalone = false,
    on_attach = lsp_handlers.on_attach,
    capabilities = lsp_handlers.capabilities,

    settings = {
      ["rust-analyzer"] = {
        cargo = {
          autoReload = true,
        },
        lens = {
          enable = true,
        },
      },
    },
  },

  dap = {
    adapter = require("dap").adapters.lldb
  },
}

