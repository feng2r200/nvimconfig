local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", " ", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t", command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- no highlight
keymap("n", "<BS>", ":nohl<cr>", opts)

-- save buffer
keymap("n", "<C-s>", ":w<cr>", opts)
keymap("i", "<C-s>", "<Esc>:write<CR>i", opts)

-- remap macro record key
keymap("n", "Q", "q", opts)
-- cancel q
keymap("n", "q", "<Nop>", opts)

-- Command line
keymap("c", "<C-a>", "<Home>", opts)
keymap("c", "<C-e>", "<End>", opts)

-- Resize with arrows
keymap("n", "<C-Down>", ":resize -1<CR>", opts)
keymap("n", "<C-Up>", ":resize +1<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +1<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -1<CR>", opts)

-- Navigate buffers
keymap("n", "R", ":BufferLineCycleNext<CR>", opts)
keymap("n", "E", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "gR", ":BufferLineMoveNext<CR>", opts)
keymap("n", "gE", ":BufferLineMovePrev<CR>", opts)

-- Visual --

-- Move text up and down
keymap("v", "<C-j>", ":m '>+1<cr>gv=gv", opts)
keymap("v", "<C-k>", ":m '<-2<cr>gv=gv", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Debug
keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<F6>", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<F7>", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<F8>", "<cmd>lua require'dap'.step_out()<cr>", opts)

keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)

keymap("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions{}<cr>", opts)
keymap("n", "gD", "<cmd>lua require('telescope.builtin').lsp_implementations{}<cr>", opts)

