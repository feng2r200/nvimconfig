return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "lukas-reineke/cmp-rg",
      "andersevenrud/cmp-tmux",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "rg", group_index = 3 })
      table.insert(opts.sources, { name = "tmux", group_index = 3 })

      local cmp = require("cmp")
      opts.preselect = cmp.PreselectMode.None

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-c>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
      })
    end,
  },
}
