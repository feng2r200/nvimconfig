local M = { "aserowy/tmux.nvim", event = "BufRead" }

M.config = function()
  local status_ok, tmux = pcall(require, "tmux")
  if not status_ok then
    return
  end

  tmux.setup({
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
      enable_default_keybindings = true,
      -- sets resize steps for x axis
      resize_step_x = 2,
      -- sets resize steps for y axis
      resize_step_y = 2,
    }
  })
end

return M
