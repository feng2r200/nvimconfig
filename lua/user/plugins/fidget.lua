local M = {
  "j-hui/fidget.nvim",
  tag = "legacy",
  event = "BufReadPost",
  after = "nvim-lspconfig",
}

M.config = function()
  require("fidget").setup {}
end

return M
