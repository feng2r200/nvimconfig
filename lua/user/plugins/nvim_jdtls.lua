local M = { "mfussenegger/nvim-jdtls", ft = "java" }

M.config = function()
  require("lsp.settings.java").init()
end

return M
