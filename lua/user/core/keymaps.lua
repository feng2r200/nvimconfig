local map = vim.keymap.set
local default_options = { silent = true }

map("", "<Space>", "<Nop>", {})
map("", "<C-t>", "<Nop>", {})

map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" } )

