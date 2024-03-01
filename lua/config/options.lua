-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "\\"

vim.g.autoformat = false

local opt = vim.opt

opt.autoread = true
opt.colorcolumn = "80,100"
opt.swapfile = false
opt.updatetime = 500
opt.writebackup = false

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
