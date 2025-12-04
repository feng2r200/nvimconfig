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
  -- Simple lua plugin for automated session management
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/util.lua
  {
    "persistence.nvim",
    enabled = false,
    event = "VimEnter",
		-- stylua: ignore
		keys = {
			{ '<localleader>s', "<cmd>lua require'persistence'.select()<CR>", desc = 'Sessions' },
		},
    opts = {
      branch = false,
      -- Enable to autoload session on startup, unless:
      -- * neovim was started with files as arguments
      -- * stdin has been provided
      -- * git commit/rebase session
      autoload = true,
    },
    init = function()
      -- Detect if stdin has been provided.
      vim.g.started_with_stdin = false
      vim.api.nvim_create_autocmd("StdinReadPre", {
        group = vim.api.nvim_create_augroup("user.persistence", {}),
        callback = function()
          vim.g.started_with_stdin = true
        end,
      })
      -- Autoload session on startup.
      local disabled_dirs = {
        vim.env.TMPDIR or "/tmp",
        "/private/tmp",
      }
      vim.api.nvim_create_autocmd("VimEnter", {
        group = "user.persistence",
        once = true,
        nested = true,
        callback = function()
          local opts = LazyVim.opts("persistence.nvim")
          if not opts.autoload then
            return
          end
          local cwd = vim.uv.cwd() or vim.fn.getcwd()
          if cwd == nil or vim.fn.argc() > 0 or vim.g.started_with_stdin or vim.env.GIT_EXEC_PATH ~= nil then
            require("persistence").stop()
            return
          end
          for _, path in pairs(disabled_dirs) do
            if cwd:sub(1, #path) == path then
              require("persistence").stop()
              return
            end
          end
          -- Close all floats before loading a session. (e.g. Lazy.nvim)
          for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(win).zindex then
              vim.api.nvim_win_close(win, false)
            end
          end
          require("persistence").load()
        end,
      })
    end,
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
  -- Seamless navigation between tmux panes and vim splits
  {
    "aserowy/tmux.nvim",
    lazy = false,
    keys = {
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        remap = true,
        desc = "Cursor Move Left",
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
        remap = true,
        desc = "Cursor Move Bottom",
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
        remap = true,
        desc = "Cursor Move Top",
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        remap = true,
        desc = "Cursor Move Right",
      },
      {
        "<C-Left>",
        function()
          require("tmux").resize_left()
        end,
        remap = true,
        desc = "Window Resize Left",
      },
      {
        "<C-Down>",
        function()
          require("tmux").resize_bottom()
        end,
        remap = true,
        desc = "Window Resize Bottom",
      },
      {
        "<C-Up>",
        function()
          require("tmux").resize_top()
        end,
        remap = true,
        desc = "Window Resize Top",
      },
      {
        "<C-Right>",
        function()
          require("tmux").resize_right()
        end,
        remap = true,
        desc = "Window Resize Right",
      },
    },
    opts = {
      copy_sync = {
        enable = false,
      },
      navigation = {
        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,
        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
      },
      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = false,
        -- sets resize steps for x axis
        resize_step_x = 2,
        -- sets resize steps for y axis
        resize_step_y = 2,
      },
    },
  },
}
