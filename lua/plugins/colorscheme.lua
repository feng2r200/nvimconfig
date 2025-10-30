---@diagnostic disable: undefined-global
return {

  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    enabled = true,
    priority = 1000,
    opts = {
      colors = {
        bg = "#1a1a1a",
        bg_statusline = "#1a1a1a",
        fg = "#e0dedf",
        float_bg = "#151517",
        cursorline = "#2b2b2b",
        line_number = "#b0a8aa",
        indentline = "#4b4b4b",
        color_column = "#1a1a1a",
        selection = "#3f3f3f",
        purple = "#c48fff",
        blue = "#6fa3fd",
        yellow = "#d9ba6f",
        orange = "#d9b078",
        white = "#e1dbdf",
        black = "#2a2a2a",
        cyan = "#5fa9b4",
        red = "#a9473e",
        gray = "#4b4b4b",
        green = "#4fa281",
      },
      highlights = {},
      styles = {
        keywords = "bold",
      },
      plugins = {
        nvim_lsp = true,
        treesitter = true,
      },
      options = {
        cursorline = true,
        highlight_inactive_windows = true,
        lualine_transparency = true,
        terminal_colors = true,
        transparency = true,
      },
    },
    config = function(_, opts)
      require("onedarkpro").setup(opts)
      require("onedarkpro.config").set_theme("onedark_vivid")
      require("onedarkpro").load()
    end,
  },
}
