return {

  -- Use last-used colorscheme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 99,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "dragon"
        },
      })

			vim.cmd("colorscheme kanagawa")
    end,
  },
}
