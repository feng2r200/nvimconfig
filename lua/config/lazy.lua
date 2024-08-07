-- Clone bootstrap repositories if not already installed.
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
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
clone("LazyVim/LazyVim.git", vim.fn.stdpath("data") .. "/lazy/LazyVim")

require("lazy").setup({
  spec = {
    { import = "plugins.lazyvim" },
    { import = "plugins" },
    { import = "lazyvim.plugins.xtras" },

    { import = "plugins.extras.dap.core" },
    { import = "plugins.extras.editor.rest" },
    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.markdown" },
    { import = "plugins.extras.lang.java" },
    { import = "plugins.extras.lang.python" },
    { import = "plugins.extras.lang.sql" },
    { import = "plugins.extras.lang.tmux" },
    { import = "plugins.extras.ui.barbecue" },
    { import = "plugins.extras.ui.symbols-outline" },

    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.test.core" },
  },
  concurrency = vim.uv.available_parallelism() * 2,
  defaults = { lazy = true, version = false },
  install = { missing = true, colorscheme = {} },
  checker = { enabled = false, notify = false },
  change_detection = { notify = false },
  diff = { cmd = "terminal_git" },
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
