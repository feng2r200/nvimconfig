local M = {}

---@class LualineConfig
local default = {
  float = true,
  separator = "bubble", -- bubble | triangle
  ---@type any
  colorful = true,
  separator_icon = { left = "", right = " " },
  thin_separator_icon = { left = "", right = " " },
}

---@type LualineConfig
M.options = {}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", {}, default, opts or {})
end

M.setup()

return M
