local M = {
  "Shatur/neovim-session-manager",
  module = "session_manager",
  cmd = "SessionManager",
  event = "BufWritePost",
}

M.config = function()
  local status_ok, session_manager = pcall(require, "session_manager")
  if not status_ok then
    return
  end

  session_manager.setup({ autosave_last_session = false })
end

return M
