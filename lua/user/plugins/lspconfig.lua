local M = {
  "neovim/nvim-lspconfig",
  requires = {
    "onsails/lspkind-nvim",
  },
}

M.config = function()
  require("user.lsp")
end

return M
