-- Plugins: Linting

return {

	-- Import LazyVim's linting spec in its entirety.
	{ import = 'lazyvim.plugins.linting' },

	-- Asynchronous linter plugin
	{
		'mfussenegger/nvim-lint',
	},
}

