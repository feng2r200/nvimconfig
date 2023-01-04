local M = { "windwp/nvim-autopairs", event = "InsertEnter" }

M.config = function()
  require "configs.autopairs"
end

return M
