_G.mivim = {}

-- term_details can be either a string for just a command or
-- a complete table to provide full access to configuration when calling Terminal:new()
mivim.user_terminals = {}
function mivim.toggle_term_cmd(term_details)
  if type(term_details) == "string" then
    term_details = { cmd = term_details, hidden = true }
  end
  local term_key = term_details.cmd
  if vim.v.count > 0 and term_details.count == nil then
    term_details.count = vim.v.count
    term_key = term_key .. vim.v.count
  end
  if mivim.user_terminals[term_key] == nil then
    mivim.user_terminals[term_key] = require("toggleterm.terminal").Terminal:new(term_details)
  end
  mivim.user_terminals[term_key]:toggle()
end

return mivim

