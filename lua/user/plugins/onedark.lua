local M = {
  "navarasu/onedark.nvim",
}

M.config = function()
  local status_ok, onedark = pcall(require, "onedark")
  if not status_ok then
    return
  end

  vim.o.background='dark'

  onedark.setup {
    style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = true,  -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false,

    -- toggle theme style ---
    toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'}, -- List of styles to toggle between
    toggle_style_key = nil,

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
    code_style = {
      comments = 'italic',
      keywords = 'bold',
      functions = 'bold',
      strings = 'none',
      variables = 'none'
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {
      Visual = { fg = '#181a1f', bg = '#e5c07b', fmt = 'bold' },
    }, -- Override highlight groups

    diagnostics = {
      darker = true,
      undercurl = true,
      background = true,
    },
  }

  onedark.load()
end

return M
