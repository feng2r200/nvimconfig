local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

treesitter.setup({
  ensure_installed = {
    "bash", "c", "cpp", "css", "dockerfile", "lua", "go",
    "gomod", "java", "json", "yaml", "latex", "make", "python",
    "rust", "html", "javascript", "typescript", "vue",
  },
  sync_install = false,
  ignore_install = {},
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = false,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    swap = {
      enable = false,
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
          ["]["] = "@function.outer",
          ["]m"] = "@class.outer",
      },
      goto_next_end = {
          ["]]"] = "@function.outer",
          ["]M"] = "@class.outer",
      },
      goto_previous_start = {
          ["[["] = "@function.outer",
          ["[m"] = "@class.outer",
      },
      goto_previous_end = {
          ["[]"] = "@function.outer",
          ["[M"] = "@class.outer",
      },
    },
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = false },
  matchup = { enable = true },
})

