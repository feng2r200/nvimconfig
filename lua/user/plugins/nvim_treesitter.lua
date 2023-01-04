local M = {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  event = { "BufRead", "BufNewFile" },
  requires = {
    { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
    { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" },
    { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
    {
      "kylechui/nvim-surround",
      after = "nvim-treesitter",
      config = function()
        require "configs.surround"
      end,
    },
  },
}

M.config = function()
  require "configs.treesitter"
end

return M
