---@diagnostic disable: undefined-global
local Util = require("util")
local map = LazyVim.safe_keymap_set

map("", "<Space>", "<Nop>", {})
map("", "<C-t>", "<Nop>", {})

-- stylua: ignore start

-- Navigation {{{

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Tabs: Many ways to navigate them
map('n', '<A-j>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<A-k>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-[>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-]>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<C-Tab>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<C-S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })

-- Moving tabs
map('n', '<A-{>', '<cmd>-tabmove<CR>', { desc = 'Tab Move Backwards' })
map('n', '<A-}>', '<cmd>+tabmove<CR>', { desc = 'Tab Move Forwards' })

-- buffers
map("n", "<leader>bd", LazyVim.ui.bufremove, { desc = "Delete Buffer" })

-- }}}
-- Selection {{{

-- Select last paste
map('n', 'vsp', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = 'Select Paste' })

-- Re-select blocks after indenting in visual/select mode
map('x', '<', '<gv', { desc = 'Indent Right and Re-select' })
map('x', '>', '>gv|', { desc = 'Indent Left and Re-select' })

-- Use tab for indenting in visual/select mode
map('x', '<Tab>', '>gv|', { desc = 'Indent Left' })
map('x', '<S-Tab>', '<gv', { desc = 'Indent Right' })

-- Better block-wise operations on selected area
local blockwise_force = function(key)
	local c_v = vim.api.nvim_replace_termcodes('<C-v>', true, false, true)
	local keyseq = {
		I  = { v = '<C-v>I',  V = '<C-v>^o^I', [c_v] = 'I' },
		A  = { v = '<C-v>A',  V = '<C-v>0o$A', [c_v] = 'A' },
		gI = { v = '<C-v>0I', V = '<C-v>0o$I', [c_v] = '0I' },
	}
	return function()
		return keyseq[key][vim.fn.mode()]
	end
end
map('x', 'I',  blockwise_force('I'),  { expr = true, noremap = true, desc = 'Blockwise Insert' })
map('x', 'gI', blockwise_force('gI'), { expr = true, noremap = true, desc = 'Blockwise Insert' })
map('x', 'A',  blockwise_force('A'),  { expr = true, noremap = true, desc = 'Blockwise Append' })

-- }}}
-- Jump to {{{

map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']a', '<cmd>lnext<CR>', { desc = 'Next Loclist' })
map('n', '[a', '<cmd>lprev<CR>', { desc = 'Previous Loclist' })

-- Diagnostic movement
local diagnostic_jump = function(count, severity)
	local severity_int = severity and vim.diagnostic.severity[severity] or nil
	if vim.fn.has('nvim-0.11') == 1 then
		return function()
			vim.diagnostic.jump({ severity = severity_int, count = count })
		end
	end
	-- Pre 0.11
	---@diagnostic disable-next-line: deprecated
	local jump = count > 0 and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	return function()
		jump({ severity = severity_int })
	end
end
map('n', ']d', diagnostic_jump(1), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_jump(-1), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_jump(1, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_jump(-1, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_jump(1, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_jump(-1, 'WARN'), { desc = 'Prev Warning' })

-- }}}

-- Coding {{{

-- Comment
map('n', 'gco', 'o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Below' })
map('n', 'gcO', 'O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Above' })

-- Formatting
map({ "n", "v" }, "<leader>cf", function() LazyVim.format({ force = true }) end, { desc = "Format" })

-- }}}
-- Search, substitute, diff {{{

-- Clear search with <Esc>
map({ "i", "n" }, "<esc>", "<cmd>nohl<cr><esc>", { desc = "Escape and Clear hlsearch" })
-- }}}
-- File operations {{{

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- }}}
-- Editor UI {{{

-- Toggle list windows
map('n', '<leader>xl', function() Util.edit.toggle_list('loclist') end, { desc = 'Toggle Location List' })
map('n', '<leader>xq', function() Util.edit.toggle_list('quickfix') end, { desc = 'Toggle Quickfix List' })

map('n', '<Leader>ce', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Set locations with diagnostics and open the list.
map('n', '<Leader>a', function()
	if vim.bo.filetype ~= 'qf' then
		vim.diagnostic.setloclist({ open = false })
	end
	Util.edit.toggle_list('loclist')
end, { desc = 'Open Location List' })

-- Show treesitter nodes under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Show Treesitter Node' })
map('n', '<leader>uI', '<cmd>InspectTree<cr>', { desc = 'Inspect Tree' })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- }}}
-- Plugins & Tools {{{

-- Lazygit
map('n', '<leader>tg', function() LazyVim.lazygit( { cwd = LazyVim.root.git() }) end, { desc = 'Lazygit (Root Dir)' })
map('n', '<leader>tG', function() LazyVim.lazygit() end, { desc = 'Lazygit (cwd)' })
map('n', '<leader>tm', LazyVim.lazygit.blame_line, { desc = 'Git Blame Line' })
map('n', '<leader>tf', function()
	local git_path = vim.api.nvim_buf_get_name(0)
	LazyVim.lazygit({args = { '-f', vim.trim(git_path) }})
end, { desc = 'Lazygit Current File History' })

map('n', '<leader>gl', function()
	LazyVim.lazygit({ args = { 'log' }, cwd = LazyVim.root.git() })
end, { desc = 'Lazygit Log' })
map('n', '<leader>gL', function()
	LazyVim.lazygit({ args = { 'log' } })
end, { desc = 'Lazygit Log (cwd)' })

-- Terminal
map('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
map('n', '<leader>tt', lazyterm, { desc = 'Terminal (Root Dir)' })
map('n', '<leader>tT', function() LazyVim.terminal() end, { desc = 'Terminal (cwd)' })

-- }}}
-- Windows and buffers {{{

-- Ultimatus Quitos
map('n', 'q', function()
	local plugins = {
		"PlenaryTestPopup",
		"grug-far",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"dbout",
		"gitsigns.blame",
		'blame',
		'fugitive',
		'fugitiveblame',
		'httpResult',
	}
	local buf = vim.api.nvim_get_current_buf()
	if vim.tbl_contains(plugins, vim.bo[buf].filetype) then
		vim.bo[buf].buflisted = false
		vim.api.nvim_win_close(0, false)
	else
		-- Find non-floating windows
		local wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, win)
			if vim.api.nvim_win_get_config(win).zindex then
				return nil
			end
			return win
		end)
		-- If last window, quit
		if #wins > 1 then
			vim.api.nvim_win_close(0, false)
		else
			vim.cmd[[quit]]
		end
	end
end, { desc = 'Close window' })

-- Toggle window zoom
LazyVim.toggle.map('sz', LazyVim.toggle.maximize)
-- }}}

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
