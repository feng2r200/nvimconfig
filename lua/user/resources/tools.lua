return {
  { "rlue/vim-barbaric", event = { "BufRead", "BufNewFile" } },

  "famiu/bufdelete.nvim",

  { "chrisbra/csv.vim", ft = "csv" },

  { "solarnz/thrift.vim", ft = "thrift" },

  { "iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },

  { "phaazon/hop.nvim", event = { "BufNewFile", "BufReadPost" }, branch = "v2" },

  "gaborvecsei/memento.nvim",

  { "b0o/SchemaStore.nvim", ft = "json" },

  { "antoinemadec/FixCursorHold.nvim", event = { "BufRead", "BufNewFile" } },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = require "user.config.telescope-config",
  },
}
