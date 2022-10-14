local nvim_config_dir = vim.fn.stdpath("config")
local nvim_bin_dir = nvim_config_dir .. "/bin"


local impatient_ok, _ = pcall(require, "impatient")
if not impatient_ok then
  print("The plugin [impatient] not found. Please run :PackerSync!")
end

local platform = require('mason-core.platform')
vim.env.PATH = nvim_bin_dir .. platform.path_sep .. vim.env.PATH

_G.MNVIM = {}

-- term_details can be either a string for just a command or
-- a complete table to provide full access to configuration when calling Terminal:new()
MNVIM.user_terminals = {}
function MNVIM.toggle_term_cmd(term_details)
  if type(term_details) == "string" then
    term_details = { cmd = term_details, hidden = true }
  end
  local term_key = term_details.cmd
  if vim.v.count > 0 and term_details.count == nil then
    term_details.count = vim.v.count
    term_key = term_key .. vim.v.count
  end
  if MNVIM.user_terminals[term_key] == nil then
    MNVIM.user_terminals[term_key] = require("toggleterm.terminal").Terminal:new(term_details)
  end
  MNVIM.user_terminals[term_key]:toggle()
end

return MNVIM

