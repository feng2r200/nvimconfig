---@diagnostic disable: undefined-global
local Util = require("lazyvim.util")

return {

  -----------------------------------------------------------------------------
  -- Automatic indentation style detection
  { "nmac427/guess-indent.nvim", lazy = false, priority = 50, opts = {} },

  -- An alternative sudo for Vim and Neovim
  { "lambdalisue/suda.vim", event = "BufRead" },

  -----------------------------------------------------------------------------
  -- FZF picker
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua
  {
    "fzf-lua",
    optional = true,
    opts = {
      defaults = {
        git_icons = vim.fn.executable("git") == 1,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Search labels, enhanced character motions
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
  {
    "flash.nvim",
    event = "VeryLazy",
    vscode = true,
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
		},
  },

  -----------------------------------------------------------------------------
  -- Create key bindings that stick
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
  {
    "which-key.nvim",
    keys = {
      -- Replace <leader>? with <leader>bk
      { "<leader>?", false },
      {
        "<leader>bk",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
    },
		-- stylua: ignore
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
					{ '[', group = 'prev' },
					{ ']', group = 'next' },
					{ 's', group = 'screen' },
					{ 'g', group = 'goto' },
					{ 'gz', group = 'surround' },
					{ 'z', group = 'fold' },
					{ '<Space>', group = '+telescope' },
					{ '<Space>d', group = '+lsp' },
					{
						'<leader>b',
						group = 'buffer',
						expand = function()
							return require('which-key.extras').expand.buf()
						end,
					},
					{ '<leader>c', group = 'code' },
					{ '<leader>d', group = 'debug' },
					{ '<leader>dp', group = 'profiler' },
					{ '<leader>ch', group = 'calls' },
					{ '<leader>f', group = 'file/find' },
					{ '<leader>fw', group = 'workspace' },
					{ '<leader>g', group = 'git' },
					{ '<leader>h', group = 'hunks', icon = { icon = ' ', color = 'red' } },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>s', group = 'search' },
					{ '<leader>sn', group = 'noice' },
					{ '<leader>t', group = 'toggle/tools' },
					{ '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
					{ '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
					-- Better descriptions
					{ 'gx', desc = 'Open with system app' },
				},
			},
		},
  },

  -----------------------------------------------------------------------------
  -- Pretty lists to help you solve all code diagnostics
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
  {
    "trouble.nvim",
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
  -- Highlight, list and search todo comments in your projects
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
  {
    "todo-comments.nvim",
    opts = { signs = false },
  },

  -----------------------------------------------------------------------------
  -- Code outline sidebar powered by LSP
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        symbols = {
          icons = {},
          filter = vim.deepcopy(LazyVim.config.kind_filter),
        },
        keymaps = {
          up_and_jump = "<up>",
          down_and_jump = "<down>",
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
  -- Ultimate undo history visualizer
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<Leader>gu", "<cmd>UndotreeToggle<CR>", desc = "Undo Tree" },
    },
  },

  -----------------------------------------------------------------------------
  -- Fancy window picker
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    keys = function(_, keys)
      local pick_window = function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id ~= nil then
          vim.api.nvim_set_current_win(picked_window_id)
        end
      end

      local swap_window = function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id ~= nil then
          local current_winnr = vim.api.nvim_get_current_win()
          local current_bufnr = vim.api.nvim_get_current_buf()
          local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
          vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
          vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
        end
      end

      local mappings = {
        { "sp", pick_window, desc = "Pick window" },
        { "sw", swap_window, desc = "Swap picked window" },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      hint = "floating-big-letter",
      show_prompt = false,
      filter_rules = {
        include_current_win = true,
        autoselect_one = true,
        bo = {
          filetype = { "notify", "noice", "neo-tree-popup" },
          buftype = { "prompt", "nofile", "quickfix" },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Pretty window for navigating LSP locations
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
		-- stylua: ignore
		keys = {
			{ '<leader>cg', '', desc = '+glance' },
			{ '<leader>cgd', '<cmd>Glance definitions<CR>', desc = 'Glance Definitions' },
			{ '<leader>cgr', '<cmd>Glance references<CR>', desc = 'Glance References' },
			{ '<leader>cgy', '<cmd>Glance type_definitions<CR>', desc = 'Glance Type Definitions' },
			{ '<leader>cgi', '<cmd>Glance implementations<CR>', desc = 'Glance implementations' },
			{ '<leader>cgu', '<cmd>Glance resume<CR>', desc = 'Glance Resume' },
		},
    opts = function()
      local actions = require("glance").actions
      return {
        folds = {
          fold_closed = "󰅂", -- 󰅂 
          fold_open = "󰅀", -- 󰅀 
          folded = true,
        },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["sg"] = actions.jump_vsplit,
            ["sv"] = actions.jump_split,
            ["st"] = actions.jump_tab,
            ["p"] = actions.enter_win("preview"),
          },
          preview = {
            ["q"] = actions.close,
            ["p"] = actions.enter_win("list"),
          },
        },
      }
    end,
  },
}
