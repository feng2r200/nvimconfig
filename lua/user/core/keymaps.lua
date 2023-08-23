local map = vim.keymap.set
local default_options = { silent = true }

map("", "<Space>", "<Nop>", {})
map("", "<C-t>", "<Nop>", {})

map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)

map("x", "<C-j>", ":m'>+1<cr>gv-gv", default_options)
map("x", "<C-k>", ":m'<-2<cr>gv-gv", default_options)

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" } )

