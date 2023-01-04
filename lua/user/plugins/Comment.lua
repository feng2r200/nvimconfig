local M = {
  "numToStr/Comment.nvim",
  module = { "Comment", "Comment.api" },
  keys = { "gc", "gb", "g<", "g>" },
}

M.config = function()
  require "configs.Comment"
end

return M
