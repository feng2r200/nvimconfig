local M = {
  "andymass/vim-matchup",
  after = "nvim-treesitter",
}

M.config = function()
  vim.cmd [[let g:matchup_matchparen_offscreen = {'method': 'popup'}]]
end

return M
