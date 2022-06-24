local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.40
    end
  end,
  open_mapping = [[<c-t>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = false,
  shading_factor = 2,
  direction = "float",
  float_opts = {
    border = "curved",
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  close_on_exit = true,
  shell = vim.o.shell,
})

