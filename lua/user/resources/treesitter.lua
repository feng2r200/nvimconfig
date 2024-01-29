return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "theHamsta/nvim-treesitter-pairs",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
      "kylechui/nvim-surround",
      { "andymass/vim-matchup", ft = { "py", "python" } },
    },
    opts = {
      ensure_installed = {},
      sync_install = false,
      ignore_install = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        disable = {"vimdoc"},
      },
      pairs = {
        enable = true,
        disable = { "sh", "bash" },
        highlight_pair_events = {}, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
        highlight_self = false, -- whether to highlight also the part of the pair under cursor (or only the partner)
        goto_right_end = false, -- whether to go to the end of the right partner or the beginning
        -- fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
        keymaps = {
          goto_partner = nil,
          delete_balanced = nil,
        },
        delete_balanced = {
          only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
          fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
          longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
          -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
        },
      },
      matchup = {
        enable = true,
        disable = { "java", "bash", "sh" },
      },
      autopairs = { enable = true },
      indent = {
        enable = true,
        disable = { "java" },
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      autotag = {
        enable = true,
        disable = {},
      },
      textobjects = {
        select = {
          enable = false,
          lookahead = true,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
        },
        swap = {
          enable = true,
        },
        lsp_interop = {
          enable = true,
          border = "none",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-surround").setup {}
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
}
