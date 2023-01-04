local M = {
  "simrat39/symbols-outline.nvim",
  event = "BufReadPost",
}

M.config = function()
  require "configs.symbols"
end

return M
