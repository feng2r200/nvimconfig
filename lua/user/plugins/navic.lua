local M = {
  "SmiteshP/nvim-navic",
  dependencies = {"nvim-web-devicons", "neovim/nvim-lspconfig"},
}

M.config = function()
  local status_ok, gps = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  gps.setup({
    highlight = true,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  })
end

return M
