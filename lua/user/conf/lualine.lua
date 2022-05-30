local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify("lualine not found!")
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = true,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = "  ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = "#98be65" },
    modified = { fg = "#ecbe7b" },
    removed = { fg = "#ec5f67" },
  },
  cond = hide_in_width
}

local file_name = {
  'filename',
  file_status = true, -- Displays file status (readonly status, modified status)
  path = 1, -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path

  shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  -- for other components. (terrible name, any suggestions?)
  symbols = {
    modified = '[+]', -- Text to show when the file is modified.
    readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]', -- Text to show for unnamed buffers.
  },
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- add gps module to get the position information
local ngps = require("nvim-gps")
local gps = {
  ngps.get_location,
  cond = ngps.is_available
}

local fileformat = {
  "fileformat",
  icons_enabled = true,
  symbols = {
      unix = "LF",
      dos  = "CRLF",
      mac  = "CR",
  },
}

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch },
    lualine_b = { diff },
    lualine_c = { gps },
    lualine_x = { diagnostics },
    lualine_y = { spaces, "encoding", filetype },
    lualine_z = { location },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { file_name },
    lualine_x = { "location" },
    lualine_y = { fileformat },
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
