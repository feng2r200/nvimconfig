local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  compile_path = fn.stdpath "data" .. "/site/lua/_compiled.lua",
  git = { clone_timeout = 120 },
  max_jobs = 20,
  display = {
    -- open_fn = function()
    --   return require("packer.util").float { border = "rounded" }
    -- end,
  },
}


--  useage
-- use {
--   "myusername/example",        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports "*" for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
--   requiring a string which matches one of these patterns, the plugin will be loaded.
-- }

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "lewis6991/impatient.nvim" -- Speed up loading Lua modules    TODO: figure out how to use this
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "kyazdani42/nvim-web-devicons" -- icons

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
  }
  use "nvim-telescope/telescope-file-browser.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"
  use "nvim-telescope/telescope-live-grep-raw.nvim"
  use "MattesGroeger/vim-bookmarks"
  use "tom-anders/telescope-vim-bookmarks.nvim"
  use "nvim-telescope/telescope-dap.nvim"

  -- Treesittetr
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "nvim-treesitter/nvim-treesitter-textobjects" -- enhance texetobject selection
  use "m-demare/hlargs.nvim"
  use "SmiteshP/nvim-gps" -- statusline shows class structure
  use "andymass/vim-matchup"

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "ray-x/lsp_signature.nvim" -- show function signature when typing
  use "tami5/lspsaga.nvim"

  -- Editor enhance
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim"
  use "windwp/nvim-ts-autotag"
  use "Shatur/neovim-session-manager"
  use "junegunn/vim-easy-align"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "lukas-reineke/cmp-under-comparator"
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "andersevenrud/cmp-tmux"
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "ray-x/cmp-treesitter"

  use "ethanholz/nvim-lastplace" -- auto return back to the last modified positon when open a file
  use "nvim-pack/nvim-spectre" -- search and replace pane
  use "haringsrob/nvim_context_vt" -- show if, for, function... end as virtual text
  use "tpope/vim-surround" -- vim surround

  use "akinsho/toggleterm.nvim" -- toggle terminal
  use "ahmedkhalf/project.nvim" -- project manager
  use "lukas-reineke/indent-blankline.nvim" -- indent blankline
  use "folke/which-key.nvim" -- which  key
  use "famiu/bufdelete.nvim"

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- Debugger
  use "ravenxrz/nvim-dap"
  use "theHamsta/nvim-dap-virtual-text"
  use "rcarriga/nvim-dap-ui"

  -- Git
  use "lewis6991/gitsigns.nvim"
  use 'sindrets/diffview.nvim'

  -- UI
  use "navarasu/onedark.nvim"

  use "kyazdani42/nvim-tree.lua" -- file explore
  use {
    "akinsho/bufferline.nvim", -- tab
    tag = "*",
  }
  use "nvim-lualine/lualine.nvim" -- status line

  use {
    "antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight
  }
  use "kevinhwang91/nvim-bqf" -- better quick fix
  use "RRethy/vim-illuminate" -- highlight undercursor word
  use "folke/todo-comments.nvim" -- todo comments
  use "simrat39/symbols-outline.nvim" -- outline
  use "norcalli/nvim-colorizer.lua" -- show color
  use "folke/trouble.nvim"
  use "j-hui/fidget.nvim" -- show lsp progress
  use "simeji/winresizer"

  -- litee family
  use "ldelossa/litee.nvim"
  use "ldelossa/litee-calltree.nvim"

  -- tools
  use "aserowy/tmux.nvim"
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install"
  }

  use "simrat39/rust-tools.nvim"
  use "mfussenegger/nvim-jdtls"
  use "chrisbra/csv.vim"
  use "solarnz/thrift.vim"

  use "mtdl9/vim-log-highlighting"
  use "dinhhuy258/vim-local-history"

  use "vim-test/vim-test"
  use {
    "rcarriga/vim-ultest",
    run = ":UpdateRemotePlugins"
  }

  use "djoshea/vim-autoread"

  use "rlue/vim-barbaric"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
