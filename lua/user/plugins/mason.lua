local M = {
  "williamboman/mason.nvim",
  after = "nvim-lspconfig",
}

M.config = function()
  require "configs.nvim-mason"
  require "lsp"
end

return M
