LazyVim.on_very_lazy(function()
	vim.filetype.add({
		filename = { Tmuxfile = 'tmux' },
	})
end)

return {
	desc = 'Tmux syntax, navigator (<C-h/j/k/l>), and completion.',
	recommended = function()
		return vim.env.TMUX ~= nil
	end,

	-----------------------------------------------------------------------------
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'tmux' })
			end

			-- Setup filetype settings
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('user_ftplugin_tmux', {}),
				pattern = 'tmux',
				callback = function()
					-- Open 'man tmux' in a vertical split with word under cursor.
					local function open_doc()
						local cword = vim.fn.expand('<cword>')
						require('man').open_page(0, { silent = true }, { 'tmux' })
						vim.fn.search(cword)
					end

					vim.opt_local.iskeyword:append('-')

					vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
						.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
						.. 'setlocal iskeyword<'
						.. '| sil! nunmap <buffer> gK'

					vim.keymap.set('n', 'gK', open_doc, { buffer = 0 })
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Seamless navigation between tmux panes and vim splits
  {
    "aserowy/tmux.nvim",
    lazy = false,
    keys = {
      { "<C-h>", function() require('tmux').move_left() end, remap = true, desc = "Cursor Move Left" },
      { "<C-j>", function() require('tmux').move_bottom() end, remap = true, desc = "Cursor Move Bottom" },
      { "<C-k>", function() require('tmux').move_top() end, remap = true, desc = "Cursor Move Top" },
      { "<C-l>", function() require('tmux').move_right() end, remap = true, desc = "Cursor Move Right" },
      { "<C-Left>", function() require('tmux').resize_left() end, remap = true, desc = "Window Resize Left" },
      { "<C-Down>", function() require('tmux').resize_bottom() end, remap = true, desc = "Window Resize Bottom" },
      { "<C-Up>", function() require('tmux').resize_top() end, remap = true, desc = "Window Resize Top" },
      { "<C-Right>", function() require('tmux').resize_right() end, remap = true, desc = "Window Resize Right" },
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
