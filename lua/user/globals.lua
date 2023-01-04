local impatient_ok, _ = pcall(require, "impatient")
if not impatient_ok then
  vim.notify("The plugin [impatient] not found. Please run :PackerSync!")
end

local nvim_config_dir = vim.fn.stdpath("config")
local nvim_bin_dir = nvim_config_dir .. "/bin"

local status_ok, platform = pcall(require, 'mason-core.platform')
if not status_ok then
  vim.notify("Mason not loaded.")
end

vim.env.PATH = nvim_bin_dir .. platform.path_sep .. vim.env.PATH

local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
  RELOADER = require
else
  RELOADER = plenary_reload.reload_module
end

RELOAD = function(...)
  return RELOADER(...)
end

-- Reload a module
R = function(name)
  RELOAD(name)
  return require(name)
end

-- Print the string representation of a Lua table
P = function(v)
  print(vim.inspect(v))
  return v
end

