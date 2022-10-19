local impatient_ok, _ = pcall(require, "impatient")
if not impatient_ok then
  print("The plugin [impatient] not found. Please run :PackerSync!")
end

local nvim_config_dir = vim.fn.stdpath("config")
local nvim_bin_dir = nvim_config_dir .. "/bin"

local platform = require('mason-core.platform')
vim.env.PATH = nvim_bin_dir .. platform.path_sep .. vim.env.PATH

