local M = {
  "navarasu/onedark.nvim",
}

M.config = function()
  local status_ok, onedark = pcall(require, "onedark")
  if not status_ok then
    return
  end

  onedark.setup {
    style = "dark",
    transparent = true,
    term_colors = true,
    ending_tildes = false,
    cmp_itemkind_reverse = false,

    -- toggle theme style ---
    toggle_style_key = nil,
    toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },

    -- Change code style ---
    -- Options are italic, bold, underline, none
    code_style = {
      comments = "italic",
      keywords = "none",
      functions = "bold",
      strings = "none",
      variables = "italic,bold",
    },

    -- Lualine options --
    lualine = {
      transparent = true,
    },

    -- Custom Highlights --
    colors = {},
    highlights = {},

    -- Plugins Config --
    diagnostics = {
      darker = true,
      undercurl = true,
      background = true,
    },
  }

  onedark.load()
end

return M
