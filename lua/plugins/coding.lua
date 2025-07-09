---@diagnostic disable: undefined-global, undefined-field
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<Space>a", nil, desc = "AI/Claude Code" },
      { "<Space>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<Space>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<Space>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<Space>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<Space>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<Space>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    opts = {
      auto_start = true,
      port_range = { min = 10000, max = 65535 },
      log_level = "warn",
      terminal_cmd = nil,

      track_selection = true,
      visual_demotion_delay_ms = 50,

      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.30,
        provider = "auto", -- "auto", "snacks", or "native"
        auto_close = true,
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Completion plugin for neovim written in Lua
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/coding/blink.lua
  {
    "blink.cmp",
    optional = true,
    enabled = true,
    opts = {
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
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = false },

        trigger = {
          prefetch_on_insert = true,
          show_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
          show_on_accept_on_trigger_character = true,
          show_on_blocked_trigger_characters = { " ", "\n", "\t" },
          show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "[" },
        },
      },

      cmdline = {
        enabled = false,
        sources = {},
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
          function(a, b)
            -- :lua vim.print(vim.lsp.protocol.CompletionItemKind)
            local is_field_a = a.kind == vim.lsp.protocol.CompletionItemKind.Field
            local is_field_b = b.kind == vim.lsp.protocol.CompletionItemKind.Field

            -- If one is a field and the other isn't, prioritize the field
            if is_field_a ~= is_field_b then
              return is_field_a -- If `a` is a field, it comes first, else `b` will come first
            end
          end,
          "score",
          "sort_text",
        },
      },

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
