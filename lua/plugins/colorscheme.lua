---@diagnostic disable: undefined-global
return {

  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    enabled = true,
    priority = 1000,
    opts = {
      colors = {
        onedark = { bg = "#101011" },
      },
      highlights = {},
      styles = {
        keywords = "bold",
      },
      plugins = {
        nvim_lsp = false,
        treesitter = false,
      },
      options = {
        transparency = true,
        lualine_transparency = true,
      },
    },
    config = function(_, opts)
      require("onedarkpro").setup(vim.tbl_deep_extend("force", opts, {}))

      vim.cmd.colorscheme("onedark_vivid")
    end,
  },

}
