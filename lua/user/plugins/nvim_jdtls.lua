local M = { "mfussenegger/nvim-jdtls", ft = "java" }

M.config = function()
  require("user.lsp.settings.java").init()
end

return M
