return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    priority = 10,
    build = "cd app && yarn install",
  },

  {
    "famiu/bufdelete.nvim",
    event = { "BufRead" },
  },

  {
    "Shatur/neovim-session-manager",
    cmd = "SessionManager",
    event = "BufWritePost",
    config = function ()
      require("session_manager").setup({ autosave_last_session = false })
    end
  },
}

