---@diagnostic disable: undefined-global, undefined-doc-name, undefined-field
-- Plugins: UI

return {

  -----------------------------------------------------------------------------
  -- Snazzy tab/bufferline
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
  {
    "bufferline.nvim",
    enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        show_close_icon = false,
        show_buffer_close_icons = false,
        always_show_bufferline = true,
        custom_areas = {
          right = function()
            local result = {}
            local root = LazyVim.root()
            table.insert(result, {
              text = "%#BufferLineTab# " .. vim.fn.fnamemodify(root, ":t"),
            })

            -- Session indicator
            if vim.v.this_session ~= "" then
              table.insert(result, { text = "%#BufferLineTab#  " })
            end
            return result
          end,
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Replaces the UI for messages, cmdline and the popupmenu
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
  {
    "noice.nvim",
    ---@type NoiceConfig
    opts = {
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
      },
      cmdline = {
        view = "cmdline",
      },
    },
  },

	-----------------------------------------------------------------------------
	-- Collection of small QoL plugins
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/util.lua
	{
		'folke/snacks.nvim',
		opts = {
			dashboard = { enabled = false },
			scroll = { enabled = false },
      explorer = { enabled = false },
			terminal = {
				win = { style = 'terminal', wo = { winbar = '' } },
			},
			zen = {
				toggles = { git_signs = true },
				zoom = {
					show = { tabline = false },
					win = { backdrop = true },
				},
			},
		},
	},
	{
		'folke/snacks.nvim',
		keys = function(_, keys)
			if LazyVim.pick.want() ~= 'snacks' then
				return
			end
			-- stylua: ignore
			local mappings = {
				{ '<localleader>n', function() Snacks.picker.notifications() end, desc = 'Notifications' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = function(_, opts)
			if LazyVim.pick.want() ~= 'snacks' then
				return
			end
			return vim.tbl_deep_extend('force', opts or {}, {
				picker = {
					win = {
						input = {
							keys = {
								['jj'] = { '<esc>', expr = true, mode = 'i' },
								['sv'] = 'edit_split',
								['sg'] = 'edit_vsplit',
								['st'] = 'edit_tab',
								['.'] = 'toggle_hidden',
								[','] = 'toggle_ignored',
								['e'] = 'qflist',
								['E'] = 'loclist',
								['K'] = 'select_and_prev',
								['J'] = 'select_and_next',
								['*'] = 'select_all',
								['<c-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
								['<c-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
							},
						},
						list = {
							keys = {
								['<c-l>'] = 'preview_scroll_right',
								['<c-h>'] = 'preview_scroll_left',
							},
						},
						preview = {
							keys = {
								['<c-h>'] = 'focus_input',
								['<c-l>'] = 'cycle_win',
							},
						},
					},
				},
			})
		end,
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

  -- VS Code like winbar
  {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      attach_navic = true,
      show_navic = true,

      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      show_dirname = true,
    },
  },
}
