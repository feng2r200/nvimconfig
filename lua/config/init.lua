---@diagnostic disable: undefined-global
-- This uses LazyVim's config module.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

local M = {}

---@type table<string, string>
M.deprecated_extras = {}

---@param name 'autocmds' | 'options' | 'keymaps'
function M.load(name)
	local mod = 'config.' .. name
	if require('lazy.core.cache').find(mod)[1] then
		LazyVim.try(function()
			require(mod)
		end, { msg = 'Failed loading ' .. mod })
	end

	if vim.bo.filetype == 'lazy' then
		vim.cmd([[do VimResized]])
	end

	if name == 'options' then
		require('config').setup()
	end
end

-- Check if table has a value that ends with a suffix.
---@param tbl table
---@param suffix string
---@return boolean
local function tbl_endswith(tbl, suffix)
	local l = #suffix
	for _, v in ipairs(tbl) do
		if string.sub(v, -l) == suffix then
			return true
		end
	end
	return false
end

function M.setup()
	-- Overload deprecated extras.
	local extras = require('lazyvim.util.plugin').deprecated_extras
	for k, v in pairs(M.deprecated_extras) do
		extras[k] = v
	end

	-- Check if extra is enabled, regardless of the first namespace.
	---@param extra string
	LazyVim.has_extra = function(extra)
		local modname = '.extras.' .. extra
		if tbl_endswith(require('lazy.core.config').spec.modules, modname) then
			return true
		end
		return tbl_endswith(require('lazyvim.config').json.data.extras, modname)
	end

	-- Use Telescope by default.
	---@return "telescope" | "fzf" | "snacks"
	LazyVim.pick.want = function()
		vim.g.lazyvim_picker = vim.g.lazyvim_picker or 'auto'
		if vim.g.lazyvim_picker == 'auto' then
			return LazyVim.has_extra('editor.snacks_picker') and 'snacks'
				or LazyVim.has_extra('editor.fzf') and 'fzf'
				or 'telescope'
		end
		return vim.g.lazyvim_picker
	end
end

return M
