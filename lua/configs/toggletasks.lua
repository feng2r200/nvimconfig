local status_ok, toggletasks = pcall(require, "toggletasks")
if not status_ok then
  vim.notify("toggletasks not exists")
end

toggletasks.setup({
  search_paths = {
    ".tasks",
    ".toggletasks",
    ".nvim/toggletasks",
    ".nvim/tasks",
  },
  toggleterm = {
    close_on_exit = true,
  },
})

