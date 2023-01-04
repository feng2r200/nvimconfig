local M = { "ahmedkhalf/project.nvim", after = "telescope.nvim" }

M.config = function()
  require "configs.project"
end

return M
