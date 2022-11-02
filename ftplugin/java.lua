--[[
    Settings for mfussenegger/nvim-jdtls
--]]

vim.opt_local.foldcolumn = "1"
vim.opt_local.foldenable = true
vim.opt_local.signcolumn = "yes"

-- Mappings.
vim.api.nvim_set_keymap(
  "n",
  "crv",
  "<cmd>lua require('jdtls').extract_variable()<CR>",
  { noremap = true, silent = true, desc = "Extract variable" }
)
vim.api.nvim_set_keymap(
  "v",
  "crv",
  "<cmd>lua require('jdtls').extract_variable(true)<CR>",
  { noremap = true, silent = true, desc = "Extract variable" }
)
vim.api.nvim_set_keymap(
  "n",
  "crc",
  "<cmd>lua require('jdtls').extract_constant()<CR>",
  { noremap = true, silent = true, desc = "Extract constant" }
)
vim.api.nvim_set_keymap(
  "v",
  "crc",
  "<cmd>lua require('jdtls').extract_constant(true)<CR>",
  { noremap = true, silent = true, desc = "Extract constant" }
)
vim.api.nvim_set_keymap(
  "v",
  "crm",
  "<cmd>lua require('jdtls').extract_method(true)<CR>",
  { noremap = true, silent = true, desc = "Extract method" }
)

local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    d = {
      r = { "<cmd>lua require('dap').continue()<CR>", "Debug run" },
      m = { "<cmd>lua require('jdtls').test_class()<CR>", "Test class" },
      n = { "<cmd>lua require('jdtls').test_nearest_method()<CR>", "Test nearest method" },
    },
  }

  wk.register(mappings, {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  })
end
