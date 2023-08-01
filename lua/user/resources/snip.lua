local Icon = require "user.utils.icons"

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local types = require "luasnip.util.types"

      require("luasnip").config.set_config {
        history = false,
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
              virt_text = { { Icon.ui.BigUnfilledCircle, "Comment" } },
            },
          },
        },
        ext_base_prio = 300,
        ext_prio_increase = 1,
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ft_func = function()
          return vim.split(vim.bo.filetype, ".", true)
        end,
      }

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").load { paths = { vim.fn.stdpath "config" .. "/my-snippets" } }

      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },

  {
    "danymat/neogen",
    opt = {
      snippet_engine = "luasnip",
      enabled = true, --if you want to disable Neogen
      input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    },
  },
}
