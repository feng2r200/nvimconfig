local M = {
  "Shatur/neovim-session-manager",
  module = "session_manager",
  cmd = "SessionManager",
  event = "BufWritePost",
}

M.config = function()
  require "configs.session_manager"
end

return M
