local M = {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  requires = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "p00f/nvim-ts-rainbow",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "kylechui/nvim-surround",
    "andymass/vim-matchup",
  },
}

M.config = function()
  require("nvim-treesitter.configs").setup {
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
    },
    sync_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
      disable = {},
    },
    matchup = {
      enable = true,
      disable_virtual_text = false,
      disable = {},
    },
    autopairs = { enable = true },
    indent = {
      enable = true,
      disable = {},
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    autotag = {
      enable = true,
      disable = {},
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
      disable = {},
    },
    textobjects = {
      select = {
        enable = false,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["at"] = "@class.outer",
          ["it"] = "@class.inner",
          ["ac"] = "@call.outer",
          ["ic"] = "@call.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
          ["a/"] = "@comment.outer",
          ["i/"] = "@comment.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["as"] = "@statement.outer",
          ["is"] = "@scopename.inner",
          ["aA"] = "@attribute.outer",
          ["iA"] = "@attribute.inner",
          ["aF"] = "@frame.outer",
          ["iF"] = "@frame.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]]"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]["] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[["] = "@function.outer",
          ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[]"] = "@function.outer",
          ["[C"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<Space>."] = "@parameter.inner",
        },
        swap_previous = {
          ["<Space>,"] = "@parameter.inner",
        },
      },
      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {
          ["<Space>df"] = "@function.outer",
          ["<Space>dF"] = "@class.outer",
        },
      },
    },
  }

  require("nvim-surround").setup {}

  vim.cmd [[let g:matchup_matchparen_offscreen = {'method': 'popup'}]]
end

return M
