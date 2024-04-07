return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "lukas-reineke/cmp-rg",
      -- "andersevenrud/cmp-tmux",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "rg", group_index = 3 })
      -- table.insert(opts.sources, { name = "tmux", group_index = 3 })

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-c>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.preselect = cmp.PreselectMode.None
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/my-snippets", vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
      })
    end,
  },
}
