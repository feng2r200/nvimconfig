local M = {}

---@class LazyVimOptions
M.defaults = {
	-- String like `habamax` or a function that will load the colorscheme.
	-- Disabled by default to allow theme-loader.nvim to manage the colorscheme.
	---@type string|fun()
	colorscheme = function() end,

	-- Load the default settings
	-- stylua: ignore
	defaults = {
		autocmds = true, -- config.autocmds
		keymaps = true,  -- config.keymaps
		-- config.options can't be configured here since it's loaded
		-- prematurely. You can disable loading options with the following line at
		-- the top of your lua/config/setup.lua or init.lua:
		-- `package.loaded['config.options'] = true`
	},

	-- icons used by other plugins
	-- stylua: ignore
	icons = {
		misc = {
			dots = '󰇘',
			git = ' ',
		},
		dap = {
			Stopped             = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
			Breakpoint          = ' ',
			BreakpointCondition = ' ',
			BreakpointRejected  = { ' ', 'DiagnosticError' },
			LogPoint            = '.>',
		},
		diagnostics = {
			Error = '✘', --   ✘
			Warn  = '󰀪', --  󰀪 ▲󰳤 󱗓 
			Info  = 'ⁱ', --    󰋼 󰋽 ⚑ⁱ
			Hint  = '', --  󰌶 
		},
		status = {
			git = {
				added    = '₊', --  ₊
				modified = '∗', --  ∗
				removed  = '₋', --  ₋
			},
			diagnostics = {
				error = ' ',
				warn  = ' ',
				info  = ' ',
				hint  = ' ',
			},
			filename = {
				modified = '+',
				readonly = '🔒',
				zoomed   = '🔎',
			},
		},
		-- Default completion kind symbols.
		kinds = {
			Array         = '󰅪 ', --  󰅪 󰅨 󱃶
			Boolean       = '󰨙 ', --  ◩ 󰔡 󱃙 󰟡 󰨙
			Class         = '󰌗 ', --  󰌗 󰠱 𝓒
			Codeium       = '󰘦 ', -- 󰘦
			Collapsed     = ' ', -- 
			Color         = '󰏘 ', -- 󰸌 󰏘
			Constant      = '󰏿 ', --   󰏿
			Constructor   = ' ', --  󰆧   
			Control       = ' ', -- 
			Copilot       = ' ', --  
			Enum          = '󰕘 ', --  󰕘  ℰ 
			EnumMember    = ' ', --  
			Event         = ' ', --  
			Field         = ' ', --  󰄶  󰆨  󰀻 󰃒 
			File          = ' ', --    󰈔 󰈙
			Folder        = ' ', --   󰉋
			Function      = '󰊕 ', --  󰊕 
			Interface     = ' ', --    
			Key           = ' ', -- 
			Keyword       = ' ', --   󰌋 
			Method        = '󰊕 ', --  󰆧 󰊕 ƒ
			Module        = ' ', --   󰅩 󰆧 󰏗
			Namespace     = '󰦮 ', -- 󰦮   󰅩
			Null          = ' ', --  󰟢
			Number        = '󰎠 ', --  󰎠 
			Object        = ' ', --   󰅩
			Operator      = '󰃬 ', --  󰃬 󰆕 +
			Package       = ' ', --   󰏖 󰏗 󰆧
			Property      = ' ', --   󰜢   󰖷
			Reference     = '󰈝 ', --  󰈝 󰈇
			Snippet       = ' ', --  󰘌 ⮡   
			String        = ' ', --   󰅳
			Struct        = '󰆼 ', -- 󰆼   𝓢 󰙅 󱏒
			TabNine       = '󰏚 ', -- 󰏚
			Text          = ' ', --   󰉿 𝓐
			TypeParameter = ' ', --  󰊄 𝙏
			Unit          = ' ', --   󰑭 
			Value         = ' ', --   󰀬 󰎠
			Variable      = ' ', --   󰀫 
		},
	},
}

---@type LazyVimOptions
local options

function M.opts()
	return options
end

---@param user_opts? LazyVimOptions
function M.setup(user_opts)
	options = vim.tbl_deep_extend('force', M.defaults, user_opts or {}) or {}

	-- Autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load('autocmds')
	end

	local group = vim.api.nvim_create_augroup('RafiVim', { clear = true })
	vim.api.nvim_create_autocmd('User', {
		group = group,
		pattern = 'VeryLazy',
		callback = function()
			if lazy_autocmds then
				M.load('autocmds')
			end
			M.load('keymaps')
		end,
	})
end

---@param name 'autocmds' | 'options' | 'keymaps'
function M.load(name)
	local function _load(mod)
		if require('lazy.core.cache').find(mod)[1] then
			LazyVim.try(function()
				require(mod)
			end, { msg = 'Failed loading ' .. mod })
		end
	end
	_load('config.' .. name)
	if vim.bo.filetype == 'lazy' then
		vim.cmd([[do VimResized]])
	end
	local pattern = 'RafiVim' .. name:sub(1, 1):upper() .. name:sub(2)
	vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
	if M.did_init then
		return
	end
	M.did_init = true
	local plugin = require('lazy.core.config').spec.plugins.LazyVim
	if plugin then
		vim.opt.rtp:append(plugin.dir)
	end

	-- This is premature by purpose, to load the LazyVim global.
	local LazyVimConfig = require('lazyvim.config')

	-- Delay notifications till vim.notify was replaced or after 500ms
	LazyVim.lazy_notify()

	-- Load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load('options')

	LazyVim.plugin.setup()
	LazyVimConfig.json.load()

	-- Add lua/*/plugins/extras as list of "extra" sources
	LazyVim.extras.sources = {
		{
			name = 'LazyVim ',
			desc = 'LazyVim extras',
			module = 'lazyvim.plugins.extras',
		},
		{
			name = 'Rafi ',
			desc = 'Rafi extras',
			module = 'plugins.extras',
		},
		{
			name = 'User ',
			desc = 'User extras',
			module = 'plugins.extras'
		},
	}
end

return M
