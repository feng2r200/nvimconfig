local M = {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-web-devicons",
}

M.config = function()
  local status_ok, bufferline = pcall(require, "bufferline")
  if not status_ok then
    return
  end

  local icons = require("user.utils.icons")

  bufferline.setup({
    options = {
      mode = "buffers", -- set to "tabs" to only show tabpages instead
      numbers = "both", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
      close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
      right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
      indicator = {
        style = 'underline'
      },
      left_trunc_marker = icons.ui.LeftTruncMarker,
      right_trunc_marker = icons.ui.RightTruncMarker,
      buffer_close_icon = icons.ui.BufferClose,
      modified_icon = icons.ui.Circle,
      close_icon = icons.ui.Close,
      offsets = {
        { filetype = "NvimTree", text = "File Explorer", padding = 1 },
        { filetype = "neo-tree", text = "File Explorer", padding = 1 },
        { filetype = "Outline", text = "Outline", padding = 1 },
      },
      name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
        -- remove extension from markdown files for example
        if buf.name:match('%.md') then
          return vim.fn.fnamemodify(buf.name, ':t:r')
        end
      end,
      max_name_length = 20,
      max_prefix_length = 15,
      tab_size = 23,
      diagnostics = false, --| "nvim_lsp" | "coc",
      diagnostics_update_in_insert = false,
      custom_filter = function(buf_number, buf_numbers)
        -- filter out filetypes you don't want to see
        if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
          return true
        end
        -- filter out by buffer name
        if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
          return true
        end
        -- filter out based on arbitrary rules
        -- e.g. filter out vim wiki buffer from tabline in your work repo
        if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          return true
        end
        -- filter out by it's index number in list (don't show first buffer)
        if buf_numbers[1] ~= buf_number then
          return true
        end
      end,
      show_buffer_icons = true, --| false, -- disable filetype icons for buffers
      show_buffer_close_icons = true, --| false,
      show_close_icon = true, --| false,
      show_tab_indicators = true, -- | false,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin", --| "slant" | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false, --| true,
      always_show_bufferline = true, -- | false,
      sort_by =  'directory',  -- ,'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
    },
  })
end

return M
