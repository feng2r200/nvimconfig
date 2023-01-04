local M = {
  "ethanholz/nvim-lastplace",
  event = "BufRead",
  disable = true,
}

M.config = function()
  require "configs.nvim-lastplace"
end

return M
