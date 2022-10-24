M = {}

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lsp - lspconfig not loaded")
  return
end

require("lsp.nvim-mason")
require("lsp.handlers").setup()

return M
