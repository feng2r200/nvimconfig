local M = {
  "feline-nvim/feline.nvim",
  after = "nvim-web-devicons",
}

M.config = function()
  require "configs.feline"
end

return M
