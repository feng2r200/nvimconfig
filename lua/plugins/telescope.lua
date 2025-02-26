---@diagnostic disable: undefined-global, deprecated
if lazyvim_docs then
  -- In case you don't want to use `:LazyExtras`,
  -- then you need to set the option below.
  vim.g.lazyvim_picker = "telescope"
end

-- Custom actions

local myactions = {}

function myactions.send_to_qflist(prompt_bufnr)
  require("telescope.actions").send_to_qflist(prompt_bufnr)
  vim.api.nvim_command([[ botright copen ]])
end

function myactions.smart_send_to_qflist(prompt_bufnr)
  require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
  vim.api.nvim_command([[ botright copen ]])
end

--- Scroll the results window up
---@param prompt_bufnr number: The prompt bufnr
function myactions.results_scrolling_up(prompt_bufnr)
  myactions.scroll_results(prompt_bufnr, -1)
end

--- Scroll the results window down
---@param prompt_bufnr number: The prompt bufnr
function myactions.results_scrolling_down(prompt_bufnr)
  myactions.scroll_results(prompt_bufnr, 1)
end

---@param prompt_bufnr number: The prompt bufnr
---@param direction number: 1|-1
function myactions.scroll_results(prompt_bufnr, direction)
  local status = require("telescope.state").get_status(prompt_bufnr)
  local default_speed = vim.api.nvim_win_get_height(status.results_win) / 2
  local speed = status.picker.layout_config.scroll_speed or default_speed

  require("telescope.actions.set").shift_selection(prompt_bufnr, math.floor(speed) * direction)
end

-- Custom window-sizes
---@param dimensions table
---@param size integer
---@return number
local function get_matched_ratio(dimensions, size)
  for min_cols, scale in pairs(dimensions) do
    if min_cols == "lower" or size >= min_cols then
      return math.floor(size * scale)
    end
  end
  return dimensions.lower
end

local function width_tiny(_, cols, _)
  return get_matched_ratio({ [180] = 0.27, lower = 0.37 }, cols)
end

local function width_small(_, cols, _)
  return get_matched_ratio({ [180] = 0.4, lower = 0.5 }, cols)
end

local function width_medium(_, cols, _)
  return get_matched_ratio({ [180] = 0.5, [110] = 0.6, lower = 0.75 }, cols)
end

local function width_large(_, cols, _)
  return get_matched_ratio({ [180] = 0.7, [110] = 0.8, lower = 0.85 }, cols)
end

-- Enable indent-guides in telescope preview
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  group = vim.api.nvim_create_augroup("user_telescope", {}),
  callback = function(args)
    if args.buf ~= vim.api.nvim_win_get_buf(0) then
      return
    end
    vim.opt_local.listchars = vim.wo.listchars .. ",tab:▏\\ "
    vim.opt_local.list = true
    vim.opt_local.number = true
  end,
})

-- Setup Telescope
-- See telescope.nvim/lua/telescope/config.lua for defaults.
return {

  -----------------------------------------------------------------------------
  -- Find, Filter, Preview, Pick. All lua.
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/telescope.lua
  {
    "telescope.nvim",
    optional = true,
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
		-- stylua: ignore
		keys = {
			{ '<localleader>/', '<cmd>Telescope search_history<CR>', desc = 'Search History' },
			{ '<localleader>r', '<cmd>Telescope resume<CR>', desc = 'Resume Last' },
			{ '<localleader>f', '<cmd>Telescope find_files<CR>', desc = 'Find Files' },
			{ '<localleader>g', '<cmd>Telescope live_grep<CR>', desc = 'Grep' },
			{ '<localleader>b', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>', desc = 'Buffers' },
			{ '<localleader>j', '<cmd>Telescope jumplist<CR>', desc = 'Jump List' },
			{ '<localleader>m', '<cmd>Telescope marks<CR>', desc = 'Marks' },
			{ '<localleader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace Symbols' },
			{ '<localleader>v', '<cmd>Telescope registers<CR>', desc = 'Registers' },
			{ '<localleader>x', '<cmd>Telescope oldfiles<CR>', desc = 'Old Files' },
			{ '<localleader>;', '<cmd>Telescope command_history<CR>', desc = 'Command History' },
			{ '<localleader>:', '<cmd>Telescope commands<CR>', desc = 'Commands' },
			{ '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = 'Buffer Find' },


			-- LSP related
			{ '<localleader>dd', '<cmd>Telescope lsp_definitions<CR>', desc = 'Definitions' },
			{ '<localleader>di', '<cmd>Telescope lsp_implementations<CR>', desc = 'Implementations' },
			{ '<localleader>dr', '<cmd>Telescope lsp_references<CR>', desc = 'References' },
			{ '<localleader>da', '<cmd>Telescope lsp_code_actions<CR>', desc = 'Code Actions' },
			{ '<localleader>da', ':Telescope lsp_range_code_actions<CR>', mode = 'x', desc = 'Code Actions' },
			{
				'<leader>ss',
				function()
					require('telescope.builtin').lsp_document_symbols({
						symbols = LazyVim.config.get_kind_filter(),
					})
				end,
				desc = 'Goto Symbol',
			},
			{
				'<leader>sS',
				function()
					require('telescope.builtin').lsp_dynamic_workspace_symbols({
						symbols = LazyVim.config.get_kind_filter(),
					})
				end,
				desc = 'Goto Symbol (Workspace)',
			},

			-- General pickers
			{ '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<CR>', desc = 'Document Diagnostics' },
			{ '<leader>sD', '<cmd>Telescope diagnostics<CR>', desc = 'Workspace Diagnostics' },
			{ '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = 'Help Pages' },
			{ '<leader>sk', '<cmd>Telescope keymaps<CR>', desc = 'Key Maps' },
			{ '<leader>sj', '<cmd>Telescope jumplist<cr>', desc = 'Jumplist' },
			{ '<leader>sl', '<cmd>Telescope loclist<cr>', desc = 'Location List' },
			{ '<leader>sm', '<cmd>Telescope man_pages<CR>', desc = 'Man Pages' },
			{ '<leader>sq', '<cmd>Telescope quickfix<cr>', desc = 'Quickfix List' },

			{ '<leader>sw', LazyVim.pick('grep_string', { word_match = '-w' }), desc = 'Word (Root Dir)' },
			{ '<leader>sW', LazyVim.pick('grep_string', { root = false, word_match = '-w' }), desc = 'Word (cwd)' },
			{ '<leader>sw', LazyVim.pick('grep_string'), mode = 'v', desc = 'Selection (Root Dir)' },
			{ '<leader>sW', LazyVim.pick('grep_string', { root = false }), mode = 'v', desc = 'Selection (cwd)' },

			-- Git
			{ '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'Git Status' },
			{ '<leader>gr', '<cmd>Telescope git_branches<CR>', desc = 'Git Branches' },
			{ '<leader>gL', '<cmd>Telescope git_bcommits<CR>', desc = 'Git Buffer Commits' },
			{ '<leader>gh', '<cmd>Telescope git_stash<CR>', desc = 'Git Stashes' },
			{ '<leader>gc', '<cmd>Telescope git_bcommits_range<CR>', mode = { 'x', 'n' }, desc = 'Git Buffer Commits Range' },

			-- Find by...
			{
				'<leader>gt',
				function()
					require('telescope.builtin').lsp_workspace_symbols({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
				desc = 'Find Symbol',
			},
			{
				'<leader>gf',
				function()
					require('telescope.builtin').find_files({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
				desc = 'Find File',
			},
			{
				'<leader>gg', function()
					require('telescope.builtin').live_grep({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
				desc = 'Grep Cursor Word',
			},
			{
				'<leader>gg',
				function()
					require('telescope.builtin').live_grep({
						default_text = require('util.edit').get_visual_selection(),
					})
				end,
				mode = 'x',
				desc = 'Grep Cursor Word',
			},

		},
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local transform_mod = require("telescope.actions.mt").transform_mod
      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end

      local function find_command()
        if 1 == vim.fn.executable("rg") then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable("where") then
          return { "where", "/r", ".", "*" }
        end
      end

      -- Transform to Telescope proper actions.
      myactions = transform_mod(myactions)

      -- Clone the default Telescope configuration and enable hidden files.
      local has_ripgrep = vim.fn.executable("rg") == 1
      local vimgrep_args = {
        unpack(require("telescope.config").values.vimgrep_arguments),
      }
      table.insert(vimgrep_args, "--hidden")
      table.insert(vimgrep_args, "--follow")
      table.insert(vimgrep_args, "--no-ignore-vcs")
      table.insert(vimgrep_args, "--glob")
      table.insert(vimgrep_args, "!**/.git/*")

      local path_sep = jit and (jit.os == "Windows" and "\\" or "/") or package.config:sub(1, 1)

      opts = opts or {}
      opts.defaults = {
        sorting_strategy = "ascending",
        cache_picker = { num_pickers = 3 },

        prompt_prefix = "  ", -- ❯  
        selection_caret = "▍ ",
        multi_icon = " ",

        path_display = { "truncate" },
        file_ignore_patterns = { "node_modules" },
        set_env = { COLORTERM = "truecolor" },
        vimgrep_arguments = has_ripgrep and vimgrep_args or nil,

        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          horizontal = {
            height = 0.85,
          },
        },
        history = {
          path = vim.fn.stdpath("state") .. path_sep .. "telescope_history",
        },

        -- Open files in the first window that is an actual file.
        -- Use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,

				-- stylua: ignore
				mappings = {

					i = {
						['<Tab>'] = actions.move_selection_worse,
						['<S-Tab>'] = actions.move_selection_better,
						['<C-u>'] = actions.results_scrolling_up,
						['<C-d>'] = actions.results_scrolling_down,

						['<C-q>'] = myactions.smart_send_to_qflist,

						['<C-n>'] = actions.cycle_history_next,
						['<C-p>'] = actions.cycle_history_prev,

						['<C-b>'] = actions.preview_scrolling_up,
						['<C-f>'] = actions.preview_scrolling_down,
						['<C-h>'] = actions.preview_scrolling_left,
						['<C-j>'] = actions.preview_scrolling_down,
						['<C-k>'] = actions.preview_scrolling_up,
						['<C-l>'] = actions.preview_scrolling_right,

						['<c-t>'] = open_with_trouble,
						['<a-t>'] = open_with_trouble,
					},

					n = {
						['q']     = actions.close,
						['<Esc>'] = actions.close,

						['<Tab>'] = actions.move_selection_worse,
						['<S-Tab>'] = actions.move_selection_better,
						['<C-u>'] = myactions.results_scrolling_up,
						['<C-d>'] = myactions.results_scrolling_down,

						['<C-b>'] = actions.preview_scrolling_up,
						['<C-f>'] = actions.preview_scrolling_down,
						['<C-h>'] = actions.preview_scrolling_left,
						['<C-j>'] = actions.preview_scrolling_down,
						['<C-k>'] = actions.preview_scrolling_up,
						['<C-l>'] = actions.preview_scrolling_right,

						['<C-n>'] = actions.cycle_history_next,
						['<C-p>'] = actions.cycle_history_prev,

						['*'] = actions.toggle_all,
						['u'] = actions.drop_all,
						['J'] = actions.toggle_selection + actions.move_selection_next,
						['K'] = actions.toggle_selection + actions.move_selection_previous,
						[' '] = {
							actions.toggle_selection + actions.move_selection_next,
							type = 'action',
							opts = { nowait = true },
						},

						['sv'] = actions.select_horizontal,
						['sg'] = actions.select_vertical,
						['st'] = actions.select_tab,

						['w'] = myactions.smart_send_to_qflist,
						['e'] = myactions.send_to_qflist,

						['!'] = actions.edit_command_line,

						['t'] = open_with_trouble,

						['p'] = function()
							local entry = require('telescope.actions.state').get_selected_entry()
							require('util.preview').open(entry.path)
						end,

						-- Compare selected files with diffprg
						['c'] = function(prompt_bufnr)
							if #vim.g.diffprg == 0 then
								LazyVim.error('Set `g:diffprg` to use this feature')
								return
							end
							local from_entry = require('telescope.from_entry')
							local action_state = require('telescope.actions.state')
							local picker = action_state.get_current_picker(prompt_bufnr)
							local entries = {}
							for _, entry in ipairs(picker:get_multi_selection()) do
								table.insert(entries, from_entry.path(entry, false, false))
							end
							if #entries > 0 then
								table.insert(entries, 1, vim.g.diffprg)
								vim.fn.system(entries)
							end
						end,
					},
				},
      }
      opts.pickers = {
        buffers = {
          sort_lastused = true,
          sort_mru = true,
          layout_config = { width = width_large, height = 0.7 },
          mappings = {
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        find_files = {
          layout_config = { preview_width = 0.5 },
          hidden = true,
          find_command = find_command,
        },
        live_grep = {
          dynamic_preview_title = true,
        },
        colorscheme = {
          enable_preview = true,
          layout_config = { preview_width = 0.7 },
        },
        highlights = {
          layout_config = { preview_width = 0.7 },
        },
        vim_options = {
          theme = "dropdown",
          layout_config = { width = width_medium, height = 0.7 },
        },
        command_history = {
          theme = "dropdown",
          layout_config = { width = width_medium, height = 0.7 },
        },
        search_history = {
          theme = "dropdown",
          layout_config = { width = width_small, height = 0.6 },
        },
        spell_suggest = {
          theme = "cursor",
          layout_config = { width = width_tiny, height = 0.45 },
        },
        registers = {
          theme = "cursor",
          layout_config = { width = 0.35, height = 0.4 },
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
          layout_config = { width = width_medium, height = 0.7 },
        },
        lsp_definitions = {
          layout_config = { width = width_large, preview_width = 0.55 },
        },
        lsp_implementations = {
          layout_config = { width = width_large, preview_width = 0.55 },
        },
        lsp_references = {
          layout_config = { width = width_large, preview_width = 0.55 },
        },
        lsp_code_actions = {
          theme = "cursor",
          previewer = false,
          layout_config = { width = 0.3, height = 0.4 },
        },
        lsp_range_code_actions = {
          theme = "cursor",
          previewer = false,
          layout_config = { width = 0.3, height = 0.4 },
        },
      }

      return opts
    end,
  },
}
