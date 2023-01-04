local M = { "sindrets/diffview.nvim", event = "BufReadPost" }

M.config = function()
  require "configs.diffview-config"
end

return M
