-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import all plugin configurations
    { import = "plugins" },
    -- Import language-specific configurations
    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.python" },
    { import = "plugins.extras.lang.java" },
    { import = "plugins.extras.lang.typescript" },
    { import = "plugins.extras.lang.markdown" },
    { import = "plugins.extras.lang.docker" },
    { import = "plugins.extras.lang.yaml" },
    { import = "plugins.extras.lang.json" },
    { import = "plugins.extras.lang.tex" },
    { import = "plugins.extras.lang.rust" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = {
    missing = true,
    colorscheme = { "tokyonight", "catppuccin" },
  },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  git = {
    url_format = "https://github.com/%s.git",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
