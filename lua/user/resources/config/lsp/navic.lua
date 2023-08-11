local M = {}

M.attach = function(client, buffer)
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  if client.name == "null-ls" then
    return
  end

  navic.attach(client, buffer)
end

return M

