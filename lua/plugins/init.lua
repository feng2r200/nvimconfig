---@diagnostic disable: undefined-doc-name, undefined-field, undefined-global
require('config').init()

-- Terminal Mappings
local function term_nav(dir)
	---@param self snacks.terminal
	return function(self)
		return self:is_floating() and '<C-' .. dir .. '>' or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end

return {
	-- Modern plugin manager for Neovim
	{ 'folke/lazy.nvim', version = '*' },

	-- Lua functions library
	{ 'nvim-lua/plenary.nvim', lazy = false },

	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		opts = {},
		config = function(_, opts)
			local notify = vim.notify
			require('snacks').setup(opts)
			-- HACK: restore vim.notify after snacks setup and let noice.nvim take over
			-- this is needed to have early notifications show up in noice history
			if LazyVim.has('noice.nvim') then
				vim.notify = notify
			end
		end,
	},
}
