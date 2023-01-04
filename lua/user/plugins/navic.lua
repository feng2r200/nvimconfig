local M = {
  "SmiteshP/nvim-navic",
  after = "nvim-web-devicons",
  requires = "neovim/nvim-lspconfig",
}

M.config = function()
  require "configs.gps"
end

return M
