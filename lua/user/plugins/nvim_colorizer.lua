local M = {
  "norcalli/nvim-colorizer.lua",
  event = { "BufRead", "BufNewFile" },
}

M.config = function()
  require "configs.colorizer"
end

return M
