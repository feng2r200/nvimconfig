local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
  return
end

local types = require("luasnip.util.types")

ls.config.set_config({
	history = true,
	update_events = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "Comment" } },
			},
		},
		[types.insertNode] = {
      active = {
        virt_text = { { "●", "Comment" } },
      }
		},
	},
	ext_base_prio = 300,
	ext_prio_increase = 1,
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = { "./my-snippets" } }) -- Load snippets from my-snippets folder

require("luasnip.loaders.from_lua").lazy_load()
