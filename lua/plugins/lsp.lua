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
            { "<leader>cr", false },
            { "<leader>cA", false },
            { "<leader>cR", false, mode ={"n"} },
            { "<c-k>", false, mode = "i" },
            { "<leader>cli", vim.lsp.buf.incoming_calls, desc = "Incoming calls" },
            { "<leader>clo", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls" },
            { "cd", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            { "gh", function() return vim.lsp.buf.hover() end, desc = "Hover" },
            { "gH", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
            { "g.", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
            { "<leader>ca", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
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
