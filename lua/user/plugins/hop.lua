local M = { "phaazon/hop.nvim", event = { "BufNewFile", "BufReadPost" }, branch = "v1" }

M.config = function()
  require "configs.hop-config"
end

return M
