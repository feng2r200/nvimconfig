local M = { "TimUntersberger/neogit", cmd = "Neogit", requires = "nvim-lua/plenary.nvim" }

M.config = function()
  require "configs.neogit"
end

return M
