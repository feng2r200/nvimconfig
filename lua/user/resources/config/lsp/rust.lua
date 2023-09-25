local install_root_dir = vim.fn.stdpath "data" .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"
local liblldb_path = extension_path .. "/lldb/lib/liblldb.dylib"

local opts = {
  tools = {
    autoSetHints = true,
    executor = require("rust-tools/executors").termopen,

    on_initialized = function()
      --[[ vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, { ]]
      --[[   pattern = { "*.rs" }, ]]
      --[[   callback = function() ]]
      --[[     vim.lsp.codelens.refresh() ]]
      --[[   end, ]]
      --[[ }) ]]
    end,

    runnables = {
      use_telescope = true,
    },

    debuggables = {
      use_telescope = true,
    },

    inlay_hints = {
      auto = false,
      only_current_line = false,
      only_current_line_autocmd = "CursorHold",
      show_parameter_hints = true,
      show_variable_name = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = " => ",
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
    -- on_attach = lsp_handlers.on_attach,
    capabilities = require("user.resources.config.lsp.capabilities"),

    settings = {
      ["rust-analyzer"] = {
        cargo = {
          autoReload = true,
          features = "all",
        },
        check = {
          features = "all",
        },
        lens = {
          enable = true,
        },
      },
    },
  },

  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
  },
}

local M = {}
M.init = function ()
  require("rust-tools").setup(opts)
end

return M
