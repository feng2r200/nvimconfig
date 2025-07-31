return {
  { "augmentcode/augment.vim", lazy = false },

  -- Minimal and fast icon provider
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Completion plugin for neovim written in Lua
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
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
            local is_field_a = a.kind == vim.lsp.protocol.CompletionItemKind.Field
            local is_field_b = b.kind == vim.lsp.protocol.CompletionItemKind.Field
            if is_field_a ~= is_field_b then
              return is_field_a
            end
          end,
          "score",
          "sort_text",
        },
      },
      signature = { enabled = true },
    },
  },

  -- Lightweight yet powerful formatter plugin
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
      },
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_fallback = true,
      },
      format_on_save = false,
      format_after_save = false,
      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
    },
  },

  -- Asynchronous linter plugin
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        -- Configure linters per filetype
      },
      linters = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end

      local function debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      local function lint_file()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = debounce(100, lint_file),
      })
    end,
  },

  -- Fast and feature-rich surround actions
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa",
        delete = "ds",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "cs",
        update_n_lines = "gzn",
      },
    },
  },

  -- Better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }),
          c = ai.gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
  },

  -- Auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },

  -- Powerful line and block-wise commenting
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "<Leader>V", "<Plug>(comment_toggle_blockwise_current)", mode = "n", desc = "Comment" },
      { "<Leader>V", "<Plug>(comment_toggle_blockwise_visual)",  mode = "x", desc = "Comment" },
    },
    opts = function()
      local ok, tcc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        return { pre_hook = tcc.create_pre_hook() }
      end
      return {}
    end,
  },

  -- Perform diffs on blocks of code
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff", "LinediffAdd" },
    keys = {
      { "<Leader>mdf", ":Linediff<CR>",          mode = "x",              desc = "Line diff" },
      { "<Leader>mda", ":LinediffAdd<CR>",       mode = "x",              desc = "Line diff add" },
      { "<Leader>mds", "<cmd>LinediffShow<CR>",  desc = "Line diff show" },
      { "<Leader>mdr", "<cmd>LinediffReset<CR>", desc = "Line diff reset" },
    },
  },
}
