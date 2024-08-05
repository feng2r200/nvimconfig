return {

  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    enabled = true,
    priority = 1000,
    opts = {
      options = {
        cursorline = true,
        transparency = true,
        lualine_transparency = true,
      },
    },
    config = function()
      vim.cmd.colorscheme("onedark_vivid")
    end,
  },
}
