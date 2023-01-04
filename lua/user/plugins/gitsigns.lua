local M = { "lewis6991/gitsigns.nvim", event = "BufReadPost" }

M.config = function()
  require "configs.gitsigns-config"
end

return M
