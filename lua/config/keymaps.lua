-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local map = vim.keymap.set

map("", "<Space>", "<Nop>", {})
map("", "<C-t>", "<Nop>", {})

-- better up/down
vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")
vim.keymap.del({ "n", "x" }, "<Down>")
vim.keymap.del({ "n", "x" }, "<Up>")

-- buffers
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "<leader>bb")
vim.keymap.del("n", "<leader>`")

-- save file
vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")

-- lazy
vim.keymap.del("n", "<leader>l")

-- toggle options
vim.keymap.del("n", "<leader>us")
vim.keymap.del("n", "<leader>uw")
vim.keymap.del("n", "<leader>uL")
vim.keymap.del("n", "<leader>ul")
vim.keymap.del("n", "<leader>ub")

-- quit
vim.keymap.del("n", "<leader>qq")

-- highlights under cursor
vim.keymap.del("n", "<leader>ui")

-- LazyVim Changelog
vim.keymap.del("n", "<leader>L")

-- floating terminal
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- windows
vim.keymap.del("n", "<leader>ww")
vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>w-")
vim.keymap.del("n", "<leader>w|")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>|")
