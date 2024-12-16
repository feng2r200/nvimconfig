---@diagnostic disable: undefined-global, undefined-doc-name, undefined-field
-- Plugins: UI

return {

  -----------------------------------------------------------------------------
  -- Icon provider
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- UI Component Library
  { "MunifTanjim/nui.nvim", lazy = false },

  -----------------------------------------------------------------------------
  -- Replaces the UI for messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
		-- stylua: ignore
		keys = {
			{ '<leader>sn', '', desc = '+noice' },
			{ '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
			{ '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
			{ '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },
			{ '<leader>snt', function() require('noice').cmd('pick') end, desc = 'Noice Picker (Telescope/FzfLua)' },
			{ '<C-f>', function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end, silent = true, expr = true, desc = 'Scroll Forward', mode = {'i', 'n', 's'} },
			{ '<C-b>', function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true, expr = true, desc = 'Scroll Backward', mode = {'i', 'n', 's'}},
		},
    ---@type NoiceConfig
    opts = {
      cmdline = {
        view = "cmdline",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      messages = {
        view_search = false,
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      routes = {
        -- See :h ui-messages
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "^%d+ changes?; after #%d+" },
              { find = "^%d+ changes?; before #%d+" },
              { find = "^Hunk %d+ of %d+$" },
              { find = "^%d+ fewer lines;?" },
              { find = "^%d+ more lines?;?" },
              { find = "^%d+ line less;?" },
              { find = "^Already at newest change" },
              { kind = "wmsg" },
              { kind = "emsg", find = "E486" },
              { kind = "quickfix" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "^%d+ lines .ed %d+ times?$" },
              { find = "^%d+ lines yanked$" },
              { kind = "emsg", find = "E490" },
              { kind = "search_count" },
            },
          },
          opts = { skip = true },
        },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  {
    "snacks.nvim",
    opts = {
      -- See also lazyvim's lua/lazyvim/plugins/util.lua
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      -- scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { map = LazyVim.safe_keymap_set },
      words = { enabled = true },
      zen = {
        toggles = { git_signs = true },
        zoom = {
          show = { tabline = false },
          win = { backdrop = true },
        },
      },
    },
		-- stylua: ignore
		keys = {
			{ '<leader>.',  function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
			{ '<leader>S',  function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
			{ '<leader>n',  function() Snacks.notifier.show_history() end, desc = 'Notification History' },
			{ '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
			{ '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' },
		},
  },

  -----------------------------------------------------------------------------
  -- Create key bindings that stick
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cmd = "WhichKey",
    opts_extend = { "spec" },
		-- stylua: ignore
		opts = {
			preset = 'helix',
			defaults = {},
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
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Hint and fix deviating indentation
  {
    "tenxsoydev/tabs-vs-spaces.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- Highlight words quickly
  {
    "t9md/vim-quickhl",
		-- stylua: ignore
		keys = {
			{ '<Leader>mt', '<Plug>(quickhl-manual-this)', mode = { 'n', 'x' }, desc = 'Highlight word' },
		},
  },

  -----------------------------------------------------------------------------
  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    cmd = "BqfAutoToggle",
    event = "QuickFixCmdPost",
    dependencies = { "junegunn/fzf" },
    opts = {
      auto_resize_height = true,
      auto_enable = true,
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        tab = "st",
        split = "sv",
        vsplit = "sg",

        stoggleup = "K",
        stoggledown = "J",

        ptoggleitem = "p",
        ptoggleauto = "P",
        ptogglemode = "zp",

        pscrollup = "<C-b>",
        pscrolldown = "<C-f>",

        prevfile = "gk",
        nextfile = "gj",

        prevhist = "<S-Tab>",
        nexthist = "<Tab>",
      },
      preview = {
        auto_preview = true,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        should_preview_cb = function(bufnr)
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
    },
    config = function()
      vim.cmd([[
      hi BqfPreviewBorder guifg=#F2CDCD ctermfg=71
      hi link BqfPreviewRange Search
      ]])
    end,
  },
}
