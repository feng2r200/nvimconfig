local M = {
  "uloco/bluloco.nvim",
  requires = { "rktjmp/lush.nvim" },
}

M.config = function()
  require("bluloco").setup {
    style = "dark",
    transparent = true,
    italics = true,
    terminal = vim.fn.has "gui_running" == 1,
  }

  vim.cmd "colorscheme bluloco-dark"
end

return M
