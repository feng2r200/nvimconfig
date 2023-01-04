local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  requires = {
    { "nvim-telescope/telescope-fzf-native.nvim", after = "telescope.nvim", run = "make" },
    { "nvim-telescope/telescope-file-browser.nvim", after = "telescope.nvim" },
    { "benfowler/telescope-luasnip.nvim", after = "telescope.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim", after = "telescope.nvim" },
  },
}

M.config = function()
  require "configs.telescope-config"
end

return M
