local M = {
  "kyazdani42/nvim-tree.lua",
  event = { "BufRead", "BufNewFile" },
  requires = "kyazdani42/nvim-web-devicons",
}

M.config = function()
  require "configs.nvim-tree"
end

return M
