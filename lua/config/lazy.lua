local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	print('Installing lazy.nvim…')
	-- stylua: ignore
	vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Start lazy.nvim plugin manager.
require('lazy').setup({
	spec = {
		-- Load LazyVim, but without any plugins (no import).
		{
			'LazyVim/LazyVim',
			version = '*',
			priority = 10000,
			lazy = false,
			cond = true,
			opts = {},
			config = function(_, opts)
				local RafiConfig = require('config')
				RafiConfig.setup({})
				-- Setup lazyvim, but don't load lazyvim/config/* files.
				package.loaded['lazyvim.config.options'] = true
				opts = vim.tbl_deep_extend('force', RafiConfig.opts(), opts)
				require('lazyvim.config').setup(vim.tbl_deep_extend('force', opts, {
					defaults = { autocmds = false, keymaps = false },
					news = { lazyvim = false }
				}))
			end,
		},

		{ import = 'plugins' },

		-- Load LazyExtras
		{ import = 'lazyvim.plugins.xtras' },
	},
	concurrency = vim.uv.available_parallelism() * 2,
	defaults = { lazy = true, version = false },
	dev = { path = vim.fn.stdpath('config') .. '/dev' },
	install = { missing = true, colorscheme = {} },
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	ui = { border = 'rounded' },
	diff = { cmd = 'terminal_git' },
	performance = {
		rtp = {
			disabled_plugins = {
				'gzip',
				'vimballPlugin',
				'matchit',
				'matchparen',
				'2html_plugin',
				'tarPlugin',
				'netrwPlugin',
				'tutor',
				'zipPlugin',
			},
		},
	},
})
