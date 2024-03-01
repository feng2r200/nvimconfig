return {
  -- tmux support
  {
    "aserowy/tmux.nvim",
    lazy = false,
    keys = {
      { "<C-h>", function() require('tmux').move_left() end, remap = true, desc = "Cursor Move Left" },
      { "<C-j>", function() require('tmux').move_bottom() end, remap = true, desc = "Cursor Move Bottom" },
      { "<C-k>", function() require('tmux').move_top() end, remap = true, desc = "Cursor Move Top" },
      { "<C-l>", function() require('tmux').move_right() end, remap = true, desc = "Cursor Move Right" },
      { "<C-Left>", function() require('tmux').resize_left() end, remap = true, desc = "Window Resize Left" },
      { "<C-Down>", function() require('tmux').resize_bottom() end, remap = true, desc = "Window Resize Bottom" },
      { "<C-Up>", function() require('tmux').resize_top() end, remap = true, desc = "Window Resize Top" },
      { "<C-Right>", function() require('tmux').resize_right() end, remap = true, desc = "Window Resize Right" },
    },
    opts = {
      copy_sync = {
        enable = false,
      },
      navigation = {
        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,
        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
      },
      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = false,
        -- sets resize steps for x axis
        resize_step_x = 2,
        -- sets resize steps for y axis
        resize_step_y = 2,
      },
    },
  },

  {
    "hrsh7th/cmp-cmdline",
    dependencies = {
        "nvim-cmp",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline("?", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end
  },
}
