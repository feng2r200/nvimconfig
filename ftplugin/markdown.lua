vim.cmd [[setlocal conceallevel=2]]
vim.cmd [[setlocal colorcolumn=100]]

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.smartindent = false

vim.keymap.set("n", "<F12>", "<cmd>MarkdownPreviewToggle<cr>", { silent = true, desc = "Markdown preview" })

