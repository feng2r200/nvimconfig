local M = {}

M.attach = function(client, buffer)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client, buffer)
end

return M


