local M = {
  "akinsho/bufferline.nvim",
  after = "nvim-web-devicons",
}

M.config = function()
  require "configs.bufferline"
end

return M
