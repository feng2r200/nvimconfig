local M = {
  "mfussenegger/nvim-dap",
  requires = {
    { "rcarriga/nvim-dap-ui", after = "nvim-dap" },
    { "theHamsta/nvim-dap-virtual-text", after = "nvim-dap" },
  },
}

M.config = function()
  require "configs.dap-config"
end

return M
