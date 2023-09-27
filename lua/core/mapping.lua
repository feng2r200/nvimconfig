local api = require "utils.api"

local default_options = { silent = true }

local M = {}

api.map.unregister("", "<Space>", {})
api.map.unregister("", "<C-t>", {})

api.map.bulk_register {
  { mode = { "v" }, lhs = "<", rhs = "<gv", options = default_options, description = "Reduce indentation" },
  { mode = { "v" }, lhs = ">", rhs = ">gv", options = default_options, description = "Increase indentation" },
  { mode = { "n" }, lhs = "<leader>fn", rhs = "<cmd>enew<cr>", options = default_options, description = "New File" },
  {
    mode = { "t" },
    lhs = "<esc>",
    rhs = "<C-\\><C-n>",
    options = default_options,
    description = "Escape terminal insert mode",
  },
}

return M
