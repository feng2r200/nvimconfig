local M = {
  "antoinemadec/FixCursorHold.nvim",
  event = { "BufRead", "BufNewFile" },
}

M.config = function()
  vim.g.cursorhold_updatetime = 100
end

return M
