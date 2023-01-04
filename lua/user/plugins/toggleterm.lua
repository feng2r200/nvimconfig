local M = { "akinsho/toggleterm.nvim", cmd = "ToggleTerm", module = { "toggleterm", "toggleterm.terminal" } }

M.config = function()
  require "configs.toggleterm"
end

return M
