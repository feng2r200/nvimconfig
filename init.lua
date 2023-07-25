if vim.g.vscode then
  return
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.delete(lazypath, "rf")
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
    spec = "user.plugins",
    defaults = {
        lazy = false,
        version = "*",
    },
    install = { colorscheme = { "navarasu/onedark.nvim" } },
    checker = { enabled = false, notify = false },
}

require "user.globals"
require "user.options"
require "user.mappings"
require "user.autocmd"

