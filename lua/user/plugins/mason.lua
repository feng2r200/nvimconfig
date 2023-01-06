local M = {
  "williamboman/mason.nvim",
  requires = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
}

M.config = function()
  require("mason").setup {
    ui = {
      keymaps = {
        apply_language_filter = "f",
      },
    },
  }

  require("mason-lspconfig").setup {}

  require("mason-tool-installer").setup {
    ensure_installed = {
      "bash-language-server",
      "clangd",
      "css-lsp",
      "cssmodules-language-server",
      "debugpy",
      "dockerfile-language-server",
      "emmet-ls",
      "html-lsp",
      "jdtls",
      "json-lsp",
      "lemminx",
      "lua-language-server",
      "marksman",
      "pyright",
      "solidity",
      "sqls",
      "taplo",
      "terraform-ls",
      "tflint",
      "typescript-language-server",
      "yaml-language-server",
    },
    auto_update = false,
    run_on_start = false,
  }
end

return M
