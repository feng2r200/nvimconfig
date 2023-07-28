return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").load { paths = { vim.fn.stdpath "config" .. "/my-snippets" } }
        require("luasnip.loaders.from_snipmate").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load()
      end,
    },
    opts = {
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
    },
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-under-comparator",
      "hrsh7th/cmp-nvim-lua",
      "andersevenrud/cmp-tmux",
      "lukas-reineke/cmp-rg",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    opts = function()
      require("user.config.nvim_cmp")
    end,
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring {}
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    event = { "InsertEnter" },
    opts = {
      floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
      floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
      hint_scheme = "Comment", -- highlight group for the virtual text
    },
  },
}
