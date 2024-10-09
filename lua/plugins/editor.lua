---@diagnostic disable: undefined-global
local Util = require("lazyvim.util")

return {

	-----------------------------------------------------------------------------
	-- Automatic indentation style detection
	{ 'nmac427/guess-indent.nvim', lazy = false, priority = 50, opts = {} },

	-- An alternative sudo for Vim and Neovim
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	-- Ultimate undo history visualizer
	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		keys = {
			{ '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
		},
	},

	-----------------------------------------------------------------------------
	-- Search labels, enhanced character motions
	{
		'folke/flash.nvim',
		event = 'VeryLazy',
		vscode = true,
		---@diagnostic disable-next-line: undefined-doc-name
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
		-- stylua: ignore
		keys = {
			{ 'ss', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
			{ 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
			{ 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
			{ 'R', mode = { 'x', 'o' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
			{ '<C-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
		},
	},

	-----------------------------------------------------------------------------
	-- Highlight, list and search todo comments in your projects
	{
		'folke/todo-comments.nvim',
		event = 'LazyFile',
		dependencies = { 'nvim-lua/plenary.nvim' },
		-- stylua: ignore
		keys = {
			{ ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment' },
			{ '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment' },
			{ '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
			{ '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
			{ '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
			{ '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
		},
		opts = { signs = false },
	},

	-----------------------------------------------------------------------------
	-- Pretty lists to help you solve all code diagnostics
	{
		'folke/trouble.nvim',
		cmd = { 'Trouble' },
		opts = {
			modes = {
				lsp = {
					win = { position = 'right' },
				},
			},
		},
		-- stylua: ignore
		keys = {
			{ '<Leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
			{ '<Leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
			{ '<Leader>xs', '<cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
			{ '<Leader>xS', '<cmd>Trouble lsp toggle<CR>', desc = 'LSP references/definitions/... (Trouble)' },
			{ '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
			{ '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },

			{ 'gR', function() require('trouble').open('lsp_references') end, desc = 'LSP References (Trouble)' },
			{
				'[q',
				function()
					if require('trouble').is_open() then
						require('trouble').previous({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = 'Previous Trouble/Quickfix Item',
			},
			{
				']q',
				function()
					if require('trouble').is_open() then
						require('trouble').next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = 'Next Trouble/Quickfix Item',
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Persist and toggle multiple terminals
	{
		'akinsho/toggleterm.nvim',
		cmd = 'ToggleTerm',
		keys = function(_, keys)
			local function toggleterm()
				local venv = vim.b['virtual_env']
				local term = require('toggleterm.terminal').Terminal:new({
					env = venv and { VIRTUAL_ENV = venv } or nil,
					count = vim.v.count > 0 and vim.v.count or 1,
				})
				term:toggle()
			end
			local mappings = {
				{ '<C-/>', mode = { 'n', 't' }, toggleterm, desc = 'Toggle Terminal' },
				{ '<C-_>', mode = { 'n', 't' }, toggleterm, desc = 'which_key_ignore' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			open_mapping = false,
			float_opts = {
				border = 'curved',
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Code outline sidebar powered by LSP
	{
		'hedyhli/outline.nvim',
		cmd = { 'Outline', 'OutlineOpen' },
		keys = {
			{ '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
		},
		opts = function()
			local defaults = require('outline.config').defaults
			local opts = {
				symbols = {
					icons = {},
					filter = vim.deepcopy(LazyVim.config.kind_filter),
				},
				keymaps = {
					up_and_jump = '<up>',
					down_and_jump = '<down>',
				},
			}

			for kind, symbol in pairs(defaults.symbols.icons) do
				opts.symbols.icons[kind] = {
					icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
					hl = symbol.hl,
				}
			end
			return opts
		end,
	},

	-----------------------------------------------------------------------------
	-- Fancy window picker
	{
		's1n7ax/nvim-window-picker',
		event = 'VeryLazy',
		keys = function(_, keys)
			local pick_window = function()
				local picked_window_id = require('window-picker').pick_window()
				if picked_window_id ~= nil then
					vim.api.nvim_set_current_win(picked_window_id)
				end
			end

			local swap_window = function()
				local picked_window_id = require('window-picker').pick_window()
				if picked_window_id ~= nil then
					local current_winnr = vim.api.nvim_get_current_win()
					local current_bufnr = vim.api.nvim_get_current_buf()
					local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
					vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
					vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
				end
			end

			local mappings = {
				{ 'sp', pick_window, desc = 'Pick window' },
				{ 'sw', swap_window, desc = 'Swap picked window' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			hint = 'floating-big-letter',
			show_prompt = false,
			filter_rules = {
				include_current_win = true,
				autoselect_one = true,
				bo = {
					filetype = { 'notify', 'noice', 'neo-tree-popup' },
					buftype = { 'prompt', 'nofile', 'quickfix' },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Search/replace in multiple files
	{
		'MagicDuck/grug-far.nvim',
		cmd = 'GrugFar',
		opts = { headerMaxWidth = 80 },
		keys = {
			{
				'<leader>sr',
				function()
					local grug = require('grug-far')
					local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
						},
					})
				end,
				mode = { 'n', 'v' },
				desc = 'Search and Replace',
			},
		},
	},

	{
		import = 'lazyvim.plugins.extras.editor.fzf',
		enabled = function()
			return LazyVim.pick.want() == 'fzf'
		end,
	},

	{
		import = 'plugins.extras.editor.telescope',
		enabled = function()
			return LazyVim.pick.want() == 'telescope'
		end,
	},

  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<cr>", mode = { "n", "x" }, desc = "Telescope text-case" },
    },
    config = function()
      require("textcase").setup({})

      Util.on_load("telescope.nvim", function()
        require("telescope").load_extension("textcase")
      end)
    end,
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    lazy = false,
  },
}
