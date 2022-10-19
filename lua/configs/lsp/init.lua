M = {}

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("configs.lsp.nvim-mason")
require("configs.lsp.handlers").setup()

return M
