local Util = require("lazyvim.util")

return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
    },
  },

  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<cr>", mode = { "n", "x" }, desc = "Telescope text-case" },
    },
    config = function()
      require("textcase").setup({})

      Util.on_load("telescope.nvim", function()
        require("telescope").load_extension("textcase")
      end)
    end,
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    lazy = false,
  },

  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    opts = {
      attach_navic = true,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
    },
  },
}
