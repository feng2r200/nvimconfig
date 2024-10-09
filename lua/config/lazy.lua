---@diagnostic disable: undefined-global
local function clone(remote, dest)
  if not vim.uv.fs_stat(dest) then
    print("Installing " .. dest .. "…")
    remote = "https://github.com/" .. remote
    -- stylua: ignore
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', remote, '--branch=stable', dest })
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
clone("folke/lazy.nvim.git", lazypath)
vim.opt.rtp:prepend(lazypath)
clone("LazyVim/LazyVim.git", vim.fn.stdpath("data") .. "/lazy/LazyVim")

require("lazy").setup({
  spec = {
    { import = "plugins.extras.lazyvim" },
    { import = "plugins" },
    { import = "lazyvim.plugins.xtras" },

    { import = "plugins.extras.dap.core" },
    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.java" },
    { import = "plugins.extras.lang.python" },
    { import = "plugins.extras.lang.tmux" },

    { import = "plugins.extras.ui.barbecue" },
    { import = "plugins.extras.ui.leetcode" },

    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.test.core" },
  },
  defaults = { lazy = true, version = false },
  install = { missing = true, colorscheme = {} },
  checker = { enabled = false, notify = false },
  change_detection = { notify = false },
  git = {
    url_format = "git@github.com:%s",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "vimballPlugin",
        "matchit",
        "matchparen",
        "2html_plugin",
        "tarPlugin",
        "netrwPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
