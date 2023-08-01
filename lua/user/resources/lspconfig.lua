local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "onsails/lspkind-nvim",
  },
}

M.config = function()
  require("user.lsp")
end

return M
