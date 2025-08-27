---@diagnostic disable: undefined-global
-- Plugins: Git

return {

	-----------------------------------------------------------------------------
	-- Git signs written in pure lua
	-- See: https://github.com/lewis6991/gitsigns.nvim#usage
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{
		'lewis6991/gitsigns.nvim',
		event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
		opts = {
			signs = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '-' },
				topdelete    = { text = '‾' },
				changedelete = { text = '≃' },
				untracked    = { text = '?' },
			},
			signs_staged = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '-' },
				topdelete    = { text = '‾' },
				changedelete = { text = '≃' },
			},
			signcolumn          = true,  -- Toggle with `:Gitsigns toggle_signs`
			numhl               = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl              = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff           = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame  = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this
			preview_config = {
				-- Options passed to nvim_open_win
				border = 'single',
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1,
			},
			attach_to_untracked = true,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			on_attach = function(buffer)
				local gs = require('gitsigns')

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				-- Navigation
				map('n', ']h', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						gs.nav_hunk('next')
					end
				end, 'Next Hunk')

				map('n', '[h', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						gs.nav_hunk('prev')
					end
				end, 'Prev Hunk')

				map('n', ']H', function() gs.nav_hunk('last') end, 'Last Hunk')
				map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')

				-- Actions
				map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
				map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
				map('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
				map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
				map('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
				map('n', '<leader>hp', gs.preview_hunk_inline, 'Preview Hunk Inline')
				map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame Line')
				map('n', '<leader>hB', function() gs.blame() end, 'Blame Buffer')
				map('n', '<leader>hd', gs.diffthis, 'Diff This')
				map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff This ~')

				-- Text object
				map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')

				-- Toggles
				map('n', '<leader>htb', gs.toggle_current_line_blame, 'Toggle Current Line Blame')
				map('n', '<leader>htd', gs.toggle_deleted, 'Toggle Deleted')
				map('n', '<leader>hts', gs.toggle_signs, 'Toggle Signs')
				map('n', '<leader>htn', gs.toggle_numhl, 'Toggle Numhl')
				map('n', '<leader>htl', gs.toggle_linehl, 'Toggle Linehl')
				map('n', '<leader>htw', gs.toggle_word_diff, 'Toggle Word Diff')
			end,
		},
	},

	-----------------------------------------------------------------------------
	-- Tabpage interface for cycling through diffs
	{
		'sindrets/diffview.nvim',
		cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
		keys = {
			{ '<Leader>gd', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diff File' },
			{ '<Leader>gv', '<cmd>DiffviewOpen<CR>',          desc = 'Diff View' },
		},
		opts = function()
			local actions = require('diffview.actions')
			vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
				group = vim.api.nvim_create_augroup('user_diffview', {}),
				pattern = 'diffview:///panels/*',
				callback = function()
					vim.opt_local.cursorline = true
					vim.opt_local.winhighlight = 'CursorLine:WildMenu'
				end,
			})

			return {
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				keymaps = {
					view = {
						{ 'n', 'q',              actions.close },
						{ 'n', '<Tab>',          actions.select_next_entry },
						{ 'n', '<S-Tab>',        actions.select_prev_entry },
						{ 'n', '<LocalLeader>a', actions.focus_files },
						{ 'n', '<LocalLeader>e', actions.toggle_files },
					},
					file_panel = {
						{ 'n', 'q',              actions.close },
						{ 'n', 'h',              actions.prev_entry },
						{ 'n', 'o',              actions.focus_entry },
						{ 'n', 'gf',             actions.goto_file },
						{ 'n', 'sg',             actions.goto_file_split },
						{ 'n', 'st',             actions.goto_file_tab },
						{ 'n', '<C-r>',          actions.refresh_files },
						{ 'n', '<LocalLeader>e', actions.toggle_files },
					},
					file_history_panel = {
						{ 'n', 'q', '<cmd>DiffviewClose<CR>' },
						{ 'n', 'o', actions.focus_entry },
						{ 'n', 'O', actions.options },
					},
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Git blame visualizer
	{
		'FabijanZulj/blame.nvim',
		cmd = 'ToggleBlame',
		-- stylua: ignore
		keys = {
			{ '<leader>gb', '<cmd>BlameToggle virtual<CR>', desc = 'Git blame' },
			{ '<leader>gB', '<cmd>BlameToggle window<CR>',  desc = 'Git blame (window)' },
		},
		opts = {
			date_format = '%Y-%m-%d %H:%M',
			merge_consecutive = false,
			max_summary_width = 30,
			mappings = {
				commit_info = 'K',
				stack_push = '>',
				stack_pop = '<',
				show_commit = '<CR>',
				close = { '<Esc>', 'q' },
			},
		},
	},

}
