local map = vim.keymap.set
local unmap = function(modes, lhs)
	modes = type(modes) == 'string' and { modes } or modes
	lhs = type(lhs) == 'string' and { lhs } or lhs
	for _, mode in pairs(modes) do
		for _, l in pairs(lhs) do
			pcall(vim.keymap.del, mode, l)
		end
	end
end

map("", "<Space>", "<Nop>", {})
map("", "<C-t>", "<Nop>", {})

-- stylua: ignore start

-- Picker {{{

-- Bind localleader to common LazyVim picker (telescope/fzf/snacks) keymaps.
map('n', '<localleader>f', '<leader>ff', { remap = true, desc = 'Find Files (Root Dir)' })
map('n', '<localleader>F', '<leader>fF', { remap = true, desc = 'Find Files (cwd)' })
map('n', '<localleader>g', '<leader>sg', { remap = true, desc = 'Grep (Root Dir)' })
map('n', '<localleader>G', '<leader>sG', { remap = true, desc = 'Grep (cwd)' })
map('n', '<localleader>b', '<leader>,',  { remap = true, desc = 'Switch Buffer' })
map('n', '<localleader>B', '<leader>sB', { remap = true, desc = 'Grep open buffers' })
map('n', '<localleader>l', '<leader>sb', { remap = true, desc = 'Buffer lines' })
map('n', '<localleader>h', '<leader>sh', { remap = true, desc = 'Help Pages' })
map('n', '<localleader>j', '<leader>sj', { remap = true, desc = 'Jumplist' })
map('n', '<localleader>m', '<leader>sm', { remap = true, desc = 'Jump to Mark' })
map('n', '<localleader>t', '<leader>ss', { remap = true, desc = 'Goto Symbol' })
map('n', '<localleader>T', '<leader>sS', { remap = true, desc = 'Goto Symbol (Workspace)' })
map('n', '<localleader>v', '<leader>s"', { remap = true, desc = 'Registers' })
map('n', '<localleader>s', '<leader>qS', { remap = true, desc = 'Sessions' })
map('n', '<localleader>x', '<leader>fr', { remap = true, desc = 'Recent' })
map('n', '<localleader>X', '<leader>fR', { remap = true, desc = 'Recent (cwd)' })
map('n', '<localleader>;', '<leader>sc', { remap = true, desc = 'Command History' })
map('n', '<localleader>:', '<leader>sC', { remap = true, desc = 'Commands' })
map('n', '<localleader>p', '<leader>fp', { remap = true, desc = 'Projects' })
map({ 'n', 'x' }, '<leader>gg', '<leader>sw', { remap = true, desc = 'Visual selection or word (Root Dir)' })
map({ 'n', 'x' }, '<leader>gG', '<leader>sW', { remap = true, desc = 'Visual selection or word (cwd)' })

-- }}}
-- Navigation {{{

unmap('n', { '<S-h>', '<S-l>' })

-- Tabs: Many ways to navigate them
map('n', '<A-j>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<A-k>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-[>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-]>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })

-- Moving tabs
map('n', '<A-{>', '<cmd>-tabmove<CR>', { desc = 'Tab Move Backwards' })
map('n', '<A-}>', '<cmd>+tabmove<CR>', { desc = 'Tab Move Forwards' })

-- buffers
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers"})

-- }}}
-- Selection {{{

-- Select last paste
map('n', 'vsp', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = 'Select Paste' })

-- Re-select blocks after indenting in visual/select mode
map('x', '<', '<gv', { desc = 'Indent Right and Re-select' })
map('x', '>', '>gv|', { desc = 'Indent Left and Re-select' })

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

unmap('n', { 'gra', 'gri', 'grr', 'grn' })
-- Comment
map('n', 'gco', 'o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Below' })
map('n', 'gcO', 'O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Above' })

-- Formatting
map({ "n", "v" }, "<leader>cf", function() LazyVim.format({ force = true }) end, { desc = "Format" })
map({ 'n', 'x' }, '<leader>vcf', function() formatter_select() end, { desc = 'Formatter Select' })

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
map('n', '<leader>xl', function() toggle_list('loclist') end, { desc = 'Toggle Location List' })
map('n', '<leader>xq', function() toggle_list('quickfix') end, { desc = 'Toggle Quickfix List' })

map('n', '<Leader>ce', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Set locations with diagnostics and open the list.
map('n', '<Leader>a', function()
	if vim.bo.filetype ~= 'qf' then
		vim.diagnostic.setloclist({ open = false })
	end
	toggle_list('loclist')
end, { desc = 'Open Location List' })

-- }}}
-- Plugins & Tools {{{

-- Jump entire buffers throughout jumplist
map('n', 'g<C-i>', function() jump_buffer(1) end, { desc = 'Jump to newer buffer' })
map('n', 'g<C-o>', function() jump_buffer(-1) end, { desc = 'Jump to older buffer' })

-- Git
map('n', '<leader>gm', function() Snacks.picker.git_log_line() end, { desc = 'Git Blame Line' })
map({ 'n', 'x' }, '<leader>go', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })

-- Terminal
map('n', '<C-/>', function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = 'Terminal (Root Dir)' })
map('n', '<C-_>', function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = 'which_key_ignore' })

-- Terminal Mappings
map('t', '<esc><esc>', '<C-\\><C-n>', { desc = 'Enter Normal Mode' })
map('t', '<C-/>', '<cmd>close<CR>', { desc = 'Hide Terminal' })
map('t', '<C-_>', '<cmd>close<CR>', { desc = 'which_key_ignore' })

-- }}}
-- Windows and buffers {{{

-- Ultimatus Quitos
if vim.F.if_nil(vim.g.window_q_mapping, false) then
	map('n', 'q', function()
		local plugins = {
			'blame',
			'checkhealth',
			'dbout',
			'fugitive',
			'fugitiveblame',
			'gitsigns-blame',
			'grug-far',
			'help',
			'httpResult',
			'lspinfo',
			'neotest-output',
			'neotest-output-panel',
			'neotest-summary',
			'notify',
			'PlenaryTestPopup',
			'qf',
			'spectre_panel',
			'startuptime',
			'tsplayground',
		}
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(plugins, vim.bo[buf].filetype) then
			vim.bo[buf].buflisted = false
			pcall(vim.api.nvim_buf_delete, buf)
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
end

-- }}}

-- FUNCTIONS
-- ===

-- Go to newer/older buffer through jumplist.
---@param direction 1 | -1
function _G.jump_buffer(direction) -- {{{
	local jumplist, curjump = unpack(vim.fn.getjumplist() or { 0, 0 })
	if #jumplist == 0 then
		return
	end
	local cur_buf = vim.api.nvim_get_current_buf()
	local jumpcmd = direction > 0 and '<C-i>' or '<C-o>'
	local searchrange = {}
	curjump = curjump + 1
	if direction > 0 then
		searchrange = vim.fn.range(curjump + 1, #jumplist)
	else
		searchrange = vim.fn.range(curjump - 1, 1, -1)
	end

	for _, i in ipairs(searchrange) do
		local nr = jumplist[i]['bufnr']
		if nr ~= cur_buf and vim.fn.bufname(nr):find('^%w+://') == nil then
			local n = tostring(math.abs(i - curjump))
			vim.notify('Executing ' .. jumpcmd .. ' ' .. n .. ' times')
			jumpcmd = vim.api.nvim_replace_termcodes(jumpcmd, true, true, true)
			vim.cmd.normal({ n .. jumpcmd, bang = true })
			break
		end
	end
end -- }}}

-- Toggle list window
---@param name "quickfix" | "loclist"
function _G.toggle_list(name) -- {{{
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == name then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	if name == 'loclist' then
		vim.cmd([[ botright lopen ]])
	else
		vim.cmd([[ botright copen ]])
	end
end -- }}}

-- Display a list of formatters and apply the selected one.
function _G.formatter_select() -- {{{
	local buf = vim.api.nvim_get_current_buf()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode())
	local cur_start, cur_end
	if is_visual then
		cur_start = vim.fn.getpos('.')
		cur_end = vim.fn.getpos('v')
	end

	-- Collect various sources of formatters.
	---@class rafi.Formatter
	---@field kind string
	---@field name string
	---@field client LazyFormatter|{active:boolean,resolved:string[]}

	---@type rafi.Formatter[]
	local sources = {}
	local fmts = LazyVim.format.resolve(buf)
	for _, fmt in ipairs(fmts) do
		vim.tbl_map(function(resolved)
			table.insert(sources, {
				kind = fmt.name,
				name = resolved,
				client = fmt,
			})
		end, fmt.resolved)
	end

	local total_sources = #sources

	-- Apply formatter source on buffer.
	---@param bufnr number
	---@param source rafi.Formatter
	local apply_source = function(bufnr, source)
		if source == nil then
			return
		end
		LazyVim.try(function()
			return source.client.format(bufnr)
		end, { msg = 'Formatter `' .. source.name .. '` failed' })
	end

	if total_sources == 1 then
		apply_source(buf, sources[1])
	elseif total_sources > 1 then
		-- Display a list of sources to choose from
		vim.ui.select(sources, {
			prompt = 'Select a formatter',
			format_item = function(item)
				return item.name .. ' (' .. item.kind .. ')'
			end,
		}, function(selected)
			if is_visual then
				-- Restore visual selection
				vim.fn.setpos('.', cur_start)
				vim.cmd([[normal! v]])
				vim.fn.setpos('.', cur_end)
			end
			apply_source(buf, selected)
		end)
	else
		vim.notify(
			'No configured formatters for this filetype.',
			vim.log.levels.WARN
		)
	end
end -- }}}

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
