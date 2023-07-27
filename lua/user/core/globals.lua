local nvim_config_dir = vim.fn.stdpath("config")
local nvim_bin_dir = nvim_config_dir .. "/bin"

local status_ok, platform = pcall(require, 'mason-core.platform')
if not status_ok then
  vim.notify("Mason not loaded.")
  return
end

vim.env.PATH = nvim_bin_dir .. platform.path_sep .. vim.env.PATH
