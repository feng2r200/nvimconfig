---@diagnostic disable: undefined-global, undefined-field
return {

  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        cmp = { enable_auto_complete = false, },
        blink = { enable_auto_complete = true, },
        provider = 'openai_compatible',
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 600, -- Increase to reduce costs and avoid rate limits
        provider_options = {
          openai_compatible = {
            api_key = 'DASHSCOPE_API_KEY',
            end_point = 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions',
            model = 'qwen2.5-coder-7b-instruct',
            name = 'Dashscope',
            stream = true,
            optional = {
              max_tokens = 256,
              top_p = 0.9,
              provider = {
                sort = 'throughput',
              },
            },
          },
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- Completion plugin for neovim written in Lua
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/coding/blink.lua
  {
    "blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ['<A-y>'] = {
          function(cmp)
            cmp.show { providers = { 'minuet' } }
          end
        },
      },

      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500, },
        ghost_text = { enabled = false, },

        trigger = {
          prefetch_on_insert = true,
          show_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
          show_on_accept_on_trigger_character = true,
          show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
          show_on_x_blocked_trigger_characters = { "'", '"', '(', '{', '[' },
        },
      },

      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer", 'minuet' },
        providers = {
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            async = false,
            score_offset = 100,
          },
        },
      },

      cmdline = {
        enabled = false,
        sources = {},
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },

      signature = { enabled = true },
    },
  },

  -----------------------------------------------------------------------------
  -- Lightweight yet powerful formatter plugin
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/formatting.lua
  {
    "conform.nvim",
    keys = {},
  },

  -----------------------------------------------------------------------------
  -- Asynchronous linter plugin
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/linting.lua
  {
    "nvim-lint",
    keys = {},
  },

  -----------------------------------------------------------------------------
  -- Fast and feature-rich surround actions
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  {
    "mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Powerful line and block-wise commenting
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		-- stylua: ignore
		keys = {
			{ '<Leader>V', '<Plug>(comment_toggle_blockwise_current)', mode = 'n', desc = 'Comment' },
			{ '<Leader>V', '<Plug>(comment_toggle_blockwise_visual)', mode = 'x', desc = 'Comment' },
		},
    opts = function(_, opts)
      local ok, tcc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        opts.pre_hook = tcc.create_pre_hook()
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Perform diffs on blocks of code
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff", "LinediffAdd" },
    keys = {
      { "<Leader>mdf", ":Linediff<CR>", mode = "x", desc = "Line diff" },
      { "<Leader>mda", ":LinediffAdd<CR>", mode = "x", desc = "Line diff add" },
      { "<Leader>mds", "<cmd>LinediffShow<CR>", desc = "Line diff show" },
      { "<Leader>mdr", "<cmd>LinediffReset<CR>", desc = "Line diff reset" },
    },
  },
}
