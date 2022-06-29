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
				virt_text = { { "●", "GruvboxOrange" } },
			},
		},
		[types.insertNode] = {
      active = {
        virt_text = { { "●", "GruvboxBlue" } },
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

ls.filetype_extend("lua", { "c" })
ls.filetype_set("cpp", { "c" })
ls.filetype_extend("all", { "_" })

require("luasnip.loaders.from_lua").lazy_load()

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = { vim.fn.stdpath "config" .. "./my-snippets" } }) -- Load snippets from my-snippets folder

