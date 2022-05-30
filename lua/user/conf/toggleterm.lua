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
  -- TODO: add my own keymapping to <space-t>
	open_mapping = [[<c-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = false,
	shading_factor = 1,
	start_in_insert = true,
	insert_mappings = true,
  terminal_mappings = true,
	persist_size = false,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 3,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

