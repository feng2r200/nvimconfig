local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
}

M.config = function()
  require "configs.indent-line"
end

return M
