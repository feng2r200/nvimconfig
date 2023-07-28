local util = require("user.utils.utils")

-- globals, autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    util.load("globals")
    util.load("autocmds")
    util.load("keymaps")
  end,
})

util.load("options")

return {}

