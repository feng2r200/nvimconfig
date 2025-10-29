return {

  -----------------------------------------------------------------------------
  -- Quickstart configurations for the Nvim LSP client
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/keymaps.lua
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>cl", false },
            { "<c-k>", false, mode = "i" },
            { "<leader>cli", vim.lsp.buf.incoming_calls, desc = "Incoming calls" },
            { "<leader>clo", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls" },
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Portable package manager for Neovim
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua
  {
    "mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
}
