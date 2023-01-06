local M = {
  "neovim/nvim-lspconfig"
}

M.config = function()
  require("user.lsp")
end

return M
