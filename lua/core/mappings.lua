local is_available = mivim.is_available

local maps = { n = {}, i = {}, v = {}, t = {}, [""] = {} }

maps[""]["<Space>"] = "<Nop>"

maps.n["<BS>"] = { "<cmd>nohlsearch<cr>", desc = "No Highlight" }
maps.n["<leader>fn"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["<C-s>"] = { "<cmd>write<cr>", desc = "Force write" }
maps.i["<C-s>"] = { "<esc><cmd>write<cr>i", desc = "Force write" }

-- Navigate buffers
if is_available "bufferline.nvim" then
  maps.n["<S-r>"] = { "<cmd>BufferLineCycleNext<cr>",  desc = "Next buffer tab" }
  maps.n["<S-e>"] = { "<cmd>BufferLineCyclePrev<cr>",  desc = "Previous buffer tab" }
  maps.n[">b"] = { "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer tab right" }
  maps.n["<b"] = { "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer tab left" }
else
  maps.n["<S-r>"] = { "<cmd>bnext<cr>", desc = "Next buffer" }
  maps.n["<S-e>"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" }
end

-- GitSigns
if is_available "gitsigns.nvim" then
  maps.n["<leader>gj"] = { function() require("gitsigns").next_hunk() end, desc = "Next git hunk" }
  maps.n["<leader>gk"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous git hunk" }
  maps.n["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View git blame" }
  maps.n["<leader>gp"] = { function() require("gitsigns").preview_hunk() end, desc = "Preview git hunk" }
  maps.n["<leader>gh"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset git hunk" }
  maps.n["<leader>gr"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset git buffer" }
  maps.n["<leader>gs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage git hunk" }
  maps.n["<leader>gu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage git hunk" }
  maps.n["<leader>gd"] = { function() require("gitsigns").diffthis() end, desc = "View git diff" }
end

-- NeoTree
if is_available "neo-tree.nvim" then
  maps.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" }
end

-- Session Manager
if is_available "neovim-session-manager" then
  maps.n["<leader>Sl"] = { "<cmd>SessionManager! load_last_session<cr>", desc = "Load last session" }
  maps.n["<leader>Ss"] = { "<cmd>SessionManager! save_current_session<cr>", desc = "Save this session" }
  maps.n["<leader>Sd"] = { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
  maps.n["<leader>Sf"] = { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
  maps.n["<leader>S."] = { "<cmd>SessionManager! load_current_dir_session<cr>", desc = "Load current directory session" }
end

-- Smart Splits
if is_available "tmux.nvim" then
  -- Better window navigation
  maps.n["<C-h>"] = { function() require("tmux").move_left() end, desc = "Move to left split" }
  maps.n["<C-j>"] = { function() require("tmux").move_bottom() end, desc = "Move to below split" }
  maps.n["<C-k>"] = { function() require("tmux").move_top() end, desc = "Move to above split" }
  maps.n["<C-l>"] = { function() require("tmux").move_right() end, desc = "Move to right split" }

  -- Resize with arrows
  maps.n["<M-h>"] = { function() require("tmux").resize_left() end, desc = "Resize split left" }
  maps.n["<M-j>"] = { function() require("tmux").resize_bottom() end, desc = "Resize split down" }
  maps.n["<M-k>"] = { function() require("tmux").resize_top() end, desc = "Resize split up" }
  maps.n["<M-l>"] = { function() require("tmux").resize_right() end, desc = "Resize split right" }
else
  maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }

  maps.n["<M-h>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<M-j>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<M-k>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<M-l>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
end

-- SymbolsOutline
if is_available "symbols-outline.nvim" then
  maps.n["<leader>o"] = { "<cmd>SymbolsOutline<cr>", desc = "Symbols outline" }
end

-- Telescope
if is_available "telescope.nvim" then
  maps.n["gh"] = { function() require("telescope.builtin").lsp_references() end, desc = "Search references" }

  -- git
  maps.n["<leader>gt"] = { function() require("telescope.builtin").git_status() end, desc = "Git status" }
  maps.n["<leader>gb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branchs" }
  maps.n["<leader>gc"] = { function() require("telescope.builtin").git_commits() end, desc = "Git commits" }

  -- file
  maps.n["<leader>fb"] = { function() require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false}) end, desc = "Search buffers" }
  maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files(require('telescope.themes').get_ivy()) end, desc = "Search files" }
  maps.n["<leader>fF"] = { function() require('telescope').extensions.file_browser.file_browser() end, desc = "File browser" }
  maps.n["<leader>fw"] = { function() require('telescope').extensions.live_grep_args.live_grep_args(require('telescope.themes').get_ivy()) end, desc = "Search Text" }
  maps.n["<leader>fs"] = { function() require("telescope.builtin").lsp_document_symbols() end, desc = "Search symbols" }
  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Search help" }
  maps.n["<leader>fm"] = { function() require("telescope.builtin").marks() end, desc = "Search marks" }
  maps.n["<leader>fe"] = { function() require("telescope.builtin").oldfiles() end, desc = "Search history" }
  maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Search registers" }

  maps.n["<leader>sm"] = { function() require("telescope.builtin").man_pages() end, desc = "Search man" }

  maps.n["<leader>lD"] = { function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" }
end

-- Terminal
if is_available "toggleterm.nvim" then
  local toggle_term_cmd = mivim.toggle_term_cmd
  maps.n["<C-t>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
  maps.n["<leader>tg"] = { function() toggle_term_cmd "gitui" end, desc = "ToggleTerm gitui" }
  maps.n["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
  maps.n["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
  maps.n["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
end

-- Stay in indent mode
maps.v["<C-j>"] = { ":m'>+1<cr>gv=gv", desc = "Move current line down"}
maps.v["<C-k>"] = { ":m'<-2<cr>gv=gv", desc = "Move current line up"}
maps.v["<"] = { "<gv", desc = "unindent line" }
maps.v[">"] = { ">gv", desc = "indent line" }

mivim.set_mappings(maps)
