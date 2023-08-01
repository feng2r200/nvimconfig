local M = { "mfussenegger/nvim-jdtls", ft = "java" }

M.config = function()
  require("user.lsp.languages.java").init()
end

return M
