local M = { "phaazon/hop.nvim", event = { "BufNewFile", "BufReadPost" }, branch = "v2" }

M.config = function()
  local status_ok, hop = pcall(require, "hop")
  if not status_ok then
    vim.notify("hop not found!")
    return
  end
  hop.setup()
end

return M
