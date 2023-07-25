local M = {
  "RRethy/vim-illuminate",
  event = "BufRead",
  dependencies = "nvim-lspconfig",
}

M.config = function()
  vim.g.Illuminate_highlightUnderCursor = 0
  vim.g.Illuminate_ftblacklist = {
    "help",
    "dashboard",
    "alpha",
    "packer",
    "norg",
    "DoomInfo",
    "NvimTree",
    "Outline",
    "toggleterm",
  }
end

return M
