local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufRead", "BufNewFile" },
}

M.config = function()
  require "configs.null-ls"
end

return M
