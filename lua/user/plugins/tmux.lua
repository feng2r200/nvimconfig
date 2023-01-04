local M = { "aserowy/tmux.nvim", event = "BufRead" }

M.config = function()
  require "configs.tmux-config"
end

return M
