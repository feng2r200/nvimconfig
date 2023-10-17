-- https://github.com/folke/lazy.nvim

local api = require "utils.api"

local M = {}

local function get_lazy_options()
  return {
    root = api.path.join(vim.fn.stdpath("data"), "lazy"),
    spec = "user.resources", -- TODO
    defaults = {
      lazy = false,
      version = "*",
    },
    install = { colorscheme = { "default" } },
    checker = { enabled = false, notify = false },
    performance = {
      disabled_plugins = {
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  }
end

function M.before()
  local install_path = api.path.join(api.get_setting().get_depends_install_path(), "lazy.nvim")

  if not vim.loop.fs_stat(install_path) then
    vim.fn.delete(install_path, "rf")
    vim.fn.mkdir(install_path, "p")
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      install_path,
    }
  end

  vim.opt.runtimepath:prepend(install_path)
end

function M.load()
  -- M.lazy = require "lazy"
  -- local lazy_load_pack = api.get_lang().get_lazy_install()
  --
  -- for pack_name, pack in pairs(api.fn.get_package_from_directory(api.path.generate_absolute_path "../", { "lazy" })) do
  --   assert(pack.lazy, ("package <%s> require 'lazy' attribute"):format(pack_name))
  --
  --   pack.lazy.init = pack.lazy.init
  --     or function()
  --       if pack.register_maps then
  --         pack.register_maps()
  --       end
  --     end
  --
  --   pack.lazy.config = pack.lazy.config
  --     or function()
  --       if pack.init then
  --         pack.init()
  --       end
  --       if pack.load then
  --         pack.load()
  --       end
  --       if pack.after then
  --         pack.after()
  --       end
  --     end
  --   table.insert(lazy_load_pack, pack.lazy)
  -- end
  --
  -- M.lazy.setup(lazy_load_pack, get_lazy_options())
    require("lazy").setup(get_lazy_options())
end

function M.entry()
  M.before()
  M.load()
end

return M.entry()
