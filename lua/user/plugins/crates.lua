local M = { "Saecki/crates.nvim", event = { "BufRead Cargo.toml" } }

M.config = function()
  require "configs.crates-config"
end

return M
