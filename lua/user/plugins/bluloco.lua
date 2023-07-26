local M = {
  "uloco/bluloco.nvim",
  lazy = false,
  priority = 1000,
  dependencies = { "rktjmp/lush.nvim" },
  enabled = false,
}

M.config = function()
  require("bluloco").setup {
    style = "dark",
    transparent = true,
    italics = true,
    terminal = vim.fn.has "gui_running" == 1,
    guicursor = true,
  }

  vim.cmd "colorscheme bluloco-dark"
end

return M
