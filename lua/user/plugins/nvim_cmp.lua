local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  requires = {
    { "lukas-reineke/cmp-under-comparator", after = "nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
    { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
    { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
    { "hrsh7th/cmp-path", after = "nvim-cmp" },
    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
    { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
    { "rcarriga/cmp-dap", after = "nvim-cmp" },
    { "tzachar/cmp-tabnine", after = "nvim-cmp", run = "./install.sh" },

    -- Snippet
    {
      "L3MON4D3/LuaSnip",
      module = "luasnip",
      config = function()
        require "configs.luasnip-config"
      end,
    },
    { "rafamadriz/friendly-snippets", opt = true },
  },
}

M.config = function()
  require "configs.cmp"
end

return M
