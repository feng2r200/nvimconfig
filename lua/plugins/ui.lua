-- Plugins: UI

return {
	-- Icon provider
	{
		'echasnovski/mini.icons',
		lazy = true,
		opts = {
			file = {
				['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
				['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
			},
			filetype = {
				dotenv = { glyph = '', hl = 'MiniIconsYellow' },
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			package.preload['nvim-web-devicons'] = function()
				require('mini.icons').mock_nvim_web_devicons()
				return package.loaded['nvim-web-devicons']
			end
		end,
	},

	-- UI Component Library
	{ 'MunifTanjim/nui.nvim', lazy = false },

	-- Fancy notification manager
	{
		'rcarriga/nvim-notify',
		priority = 9000,
		keys = {
			{
				'<leader>un',
				function()
					require('notify').dismiss({ silent = true, pending = true })
				end,
				desc = 'Dismiss All Notifications',
			},
		},
		opts = {
			stages = 'static',
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		init = function()
			-- When noice is not enabled, install notify on VeryLazy
			if not LazyVim.has('noice.nvim') then
				LazyVim.on_very_lazy(function()
					vim.notify = require('notify')
				end)
			end
		end,
	},

	-- Snazzy tab/bufferline
	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
			{ '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
			{ '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
			{ '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
			{ '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
			{ '<leader>tp', '<Cmd>BufferLinePick<CR>', desc = 'Tab Pick' },
			{ '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
			{ ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
		},
		opts = {
			options = {
				mode = 'buffers',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				diagnostics = 'nvim_lsp',
				-- show_tab_indicators = true,
				-- enforce_regular_tabs = true,
				always_show_bufferline = true,
				-- indicator = {
				-- 	style = 'underline',
				-- },
				close_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				right_mouse_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				diagnostics_indicator = function(_, _, diag)
					local icons = LazyVim.config.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
					return vim.trim(ret)
				end,
				custom_areas = {
					right = function()
						local result = {}
						local root = LazyVim.root()
						table.insert(result, {
							text = '%#BufferLineTab# ' .. vim.fn.fnamemodify(root, ':t'),
						})

						-- Session indicator
						if vim.v.this_session ~= '' then
							table.insert(result, { text = '%#BufferLineTab#  ' })
						end
						return result
					end,
				},
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'center',
					},
				},
				---@param opts bufferline.IconFetcherOpts
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
		config = function(_, opts)
			require('bufferline').setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
				callback = function()
					vim.schedule(function()
						---@diagnostic disable-next-line: undefined-global
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	-- Replaces the UI for messages, cmdline and the popupmenu
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>sn', '', desc = '+noice' },
			{ '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
			{ '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
			{ '<leader>snt', function() require('noice').cmd('pick') end, desc = 'Noice Picker (Telescope/FzfLua)' },
			{ '<C-f>', function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end, silent = true, expr = true, desc = 'Scroll Forward', mode = {'i', 'n', 's'} },
			{ '<C-b>', function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true, expr = true, desc = 'Scroll Backward', mode = {'i', 'n', 's'}},
		},
		---@type NoiceConfig
		opts = {
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			messages = {
				view_search = false,
			},
			routes = {
				-- See :h ui-messages
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '^%d+ changes?; after #%d+' },
							{ find = '^%d+ changes?; before #%d+' },
							{ find = '^Hunk %d+ of %d+$' },
							{ find = '^%d+ fewer lines;?' },
							{ find = '^%d+ more lines?;?' },
							{ find = '^%d+ line less;?' },
							{ find = '^Already at newest change' },
							{ kind = 'wmsg' },
							{ kind = 'emsg', find = 'E486' },
							{ kind = 'quickfix' },
						},
					},
					view = 'mini',
				},
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '^%d+ lines .ed %d+ times?$' },
							{ find = '^%d+ lines yanked$' },
							{ kind = 'emsg', find = 'E490' },
							{ kind = 'search_count' },
						},
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = 'notify',
						any = {
							{ find = '^No code actions available$' },
							{ find = '^No information available$' },
						},
					},
					view = 'mini',
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == 'lazy' then
				vim.cmd([[messages clear]])
			end
			require('noice').setup(opts)
		end,
	},

	-- Visually display indent levels
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'LazyFile',
		keys = {
			{ '<Leader>ue', '<cmd>IBLToggle<CR>', desc = 'Toggle indent-lines' },
		},
		opts = {
			indent = {
				-- See more characters at :h ibl.config.indent.char
				char = '│', -- ▏│
				tab_char = '│',
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					'alpha',
					'checkhealth',
					'dashboard',
					'git',
					'gitcommit',
					'help',
					'lazy',
					'lazyterm',
					'lspinfo',
					'man',
					'mason',
					'neo-tree',
					'notify',
					'Outline',
					'TelescopePrompt',
					'TelescopeResults',
					'terminal',
					'toggleterm',
					'Trouble',
				},
			},
		},
	},

	-- Visualize and operate on indent scope
	{
		'echasnovski/mini.indentscope',
		event = 'LazyFile',
		opts = function(_, opts)
			opts.symbol = '│' -- ▏│
			opts.options = { try_as_border = true }
			opts.draw = {
				delay = 0,
				animation = require('mini.indentscope').gen_animation.none(),
			}
		end,
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					'alpha',
					'dashboard',
					'fzf',
					'help',
					'lazy',
					'lazyterm',
					'man',
					'mason',
					'neo-tree',
					'notify',
					'Outline',
					'toggleterm',
					'Trouble',
					'trouble',
				},
				callback = function()
					vim.b['miniindentscope_disable'] = true
				end,
			})
		end,
	},

	-- Create key bindings that stick
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		cmd = 'WhichKey',
		opts_extend = { 'spec' },
		opts = {
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					mode = { 'n', 'v' },
					{ '<Space>', group = '+telescope' },
					{ '<Space>d', group = '+lsp' },
					{ 'g', group = '+goto' },
					{ 'gz', group = '+surround' },
					{ 'gp', group = "+glance" },
					{ ']', group = '+next' },
					{ '[', group = '+prev' },

					{ '<leader>b', group = 'buffer' },
					{ '<leader>c', group = 'code' },
					{ '<leader>ch', group = 'calls' },
					{ '<leader>f', group = 'file/find' },
					{ '<leader>fw', group = 'workspace' },
					{ '<leader>g', group = 'git' },
					{ '<leader>h', group = 'hunks' },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>s', group = 'search' },
					{ '<leader>sn', group = 'noice' },
					{ '<leader>t', group = 'toggle/tools' },
					{ '<leader>u', group = 'ui' },
					{ '<leader>x', group = 'diagnostics/quickfix' },
				},
			},
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)
		end,
	},

	-- Hint and fix deviating indentation
	{
		'tenxsoydev/tabs-vs-spaces.nvim',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {},
	},

	-- Highlight words quickly
	{
		't9md/vim-quickhl',
		-- stylua: ignore
		keys = {
			{ '<Leader>mt', '<Plug>(quickhl-manual-this)', mode = { 'n', 'x' }, desc = 'Highlight word' },
		},
	},

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
		cmd = 'BqfAutoToggle',
		event = 'QuickFixCmdPost',
    dependencies = {
      "junegunn/fzf",
    },
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        should_preview_cb = function(bufnr, _)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
				tab = 'st',
				split = 'sv',
				vsplit = 'sg',

				stoggleup = 'K',
				stoggledown = 'J',

				ptoggleitem = 'p',
				ptoggleauto = 'P',
				ptogglemode = 'zp',

				pscrollup = '<C-b>',
				pscrolldown = '<C-f>',

				prevfile = 'gk',
				nextfile = 'gj',

				prevhist = '<S-Tab>',
				nexthist = '<Tab>',
      },
    },
    config = function()
      vim.cmd([[
      hi BqfPreviewBorder guifg=#F2CDCD ctermfg=71
      hi link BqfPreviewRange Search
      ]])
    end,
  },

  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = true },
    },
    opts = {
      animation = { enable = true, duration = 150, fps = 60 },
      autowidth = { enable = true },
    },
    keys = {
      { "<C-w>z", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" },
      { "<C-w>_", "<cmd>WindowsMaximizeVertically", desc = "Max vertically window" },
      { "<C-w>|", "<cmd>WindowsMaximizeHorizontally", desc = "Max horizontally window" },
      { "<C-w>=", "<cmd>WindowsEqualize", desc = "Equalize window" },
    },
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = false
    end,
  },
}
