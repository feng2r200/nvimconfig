local M = {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  event = { "BufRead" },
}

M.config = function()
  require "configs.trouble-config"
end

return M
