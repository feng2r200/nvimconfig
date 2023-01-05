local function initialize_packer()
  local packer_avail, packer = pcall(require, "packer")
  if not packer_avail then
    local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    vim.fn.delete(packer_path, "rf")
    vim.fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    }
    vim.cmd "packadd packer.nvim"
    packer_avail, packer = pcall(require, "packer")
    if not packer_avail then
      vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path .. "\n\n" .. packer)
    end
  end
  return packer
end

local plugin_dir = vim.fn.stdpath("config") .. "/lua/user/plugins"
local plugins = vim.fn.split(vim.fn.globpath(plugin_dir, "*.lua"), "\n")

local packer = initialize_packer()
packer.startup {
  function(use)
    for _, plugin in ipairs(plugins) do
      use(require(plugin:sub(#plugin_dir - 11, -5)))
    end
  end,
  config = {
    git = {
      clone_timeout = 300,
      subcommands = {
        update = "pull --ff-only --progress --rebase",
      },
    },
    max_jobs = 20,
    autoremove = true,
  },
}
