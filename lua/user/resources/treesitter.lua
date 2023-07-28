return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "lua",
        "go",
        "gomod",
        "java",
        "json",
        "yaml",
        "latex",
        "make",
        "python",
        "rust",
        "html",
        "javascript",
        "typescript",
        "vue",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "tsx",
        "vim",
        "php",
        "scss",
        "graphql",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        disable = {},
      },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      rainbow = {
        enable = true,
        query = "rainbow-parens",
        disable = { "jsx", "html" },
      },
      autotag = {
        enable = true,
        disable = {},
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = false },
        smart_rename = {
          enable = true,
          -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
          keymaps = {
            smart_rename = "grr",
          },
        },
        navigation = {
          enable = false,
          keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>",
          },
        },
      },
      autopairs = { enable = true },
      pairs = {
        enable = true,
        disable = {},
        highlight_pair_events = {}, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
        highlight_self = false, -- whether to highlight also the part of the pair under cursor (or only the partner)
        goto_right_end = false, -- whether to go to the end of the right partner or the beginning
        fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
        keymaps = {
          goto_partner = "<leader>%",
          delete_balanced = "X",
        },
        delete_balanced = {
          only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
          fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
          longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-surround").setup(opts)
    end,
  },

  {
    "HiPhish/nvim-ts-rainbow2",
    event = "BufReadPost",
  },

  {
    "nvim-treesitter/nvim-treesitter-refactor",
  },

  {
    "theHamsta/nvim-treesitter-pairs",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },

  {
    "kylechui/nvim-surround",
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "glimmer",
      "handlebars",
      "hbs",
    },
    opts = {
      enable = true,
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        "markdown",
        "glimmer",
        "handlebars",
        "hbs",
      },
    },
  },
}
