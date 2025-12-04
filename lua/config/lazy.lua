local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.uv = vim.uv or vim.loop

local function clone(remote, dest)
  if not vim.uv.fs_stat(dest) then
    print("Installing " .. dest .. "…")
    remote = "https://github.com/" .. remote
    -- stylua: ignore
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', remote, '--branch=stable', dest })
  end
end
clone("folke/lazy.nvim.git", lazypath)
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

for _, name in pairs({ "options", "autocmds", "keymaps" }) do
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("User." .. name, { clear = true }),
    pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2) .. "Defaults",
    once = true,
    callback = function()
      require("config").load(name)
    end,
  })
end

require("lazy").setup({
  spec = {
    { import = "plugins.extras.lazyvim" },
    { import = "plugins" },

    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.test.core" },

    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.python" },

    { import = "plugins.extras.ai.avante" },
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
