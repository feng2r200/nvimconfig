local plugins = {
  -- Plugin manager
  ["wbthomason/packer.nvim"] = {},

  -- Lua Development
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },
  ["nvim-lua/popup.nvim"] = {},

  -- LSP
  ["neovim/nvim-lspconfig"] = {},
  ["williamboman/mason.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "configs.nvim-mason"
      require "lsp"
    end,
  },
  ["williamboman/mason-lspconfig.nvim"] = { after = "nvim-lspconfig" },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require "configs.null-ls"
    end,
  },
  ["ray-x/lsp_signature.nvim"] = { after = "nvim-lspconfig" },
  ["SmiteshP/nvim-navic"] = {
    after = "nvim-web-devicons",
    requires = "neovim/nvim-lspconfig",
    config = function()
      require "configs.gps"
    end,
  },
  ["simrat39/symbols-outline.nvim"] = {
    event = "BufReadPost",
    config = function()
      require "configs.symbols"
    end,
  },
  ["b0o/SchemaStore.nvim"] = { module = "schemastore" },
  ["RRethy/vim-illuminate"] = {
    event = "BufRead",
    after = "nvim-lspconfig",
    config = function()
      vim.g.Illuminate_highlightUnderCursor = 0
      vim.g.Illuminate_ftblacklist = {
        "help",
        "dashboard",
        "alpha",
        "packer",
        "norg",
        "DoomInfo",
        "NvimTree",
        "Outline",
        "toggleterm",
      }
    end,
  },
  ["andymass/vim-matchup"] = {
    after = "nvim-treesitter",
    config = function()
      vim.cmd [[let g:matchup_matchparen_offscreen = {'method': 'popup'}]]
    end,
  },

  -- Completion
  ["hrsh7th/nvim-cmp"] = {
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require "configs.cmp"
    end,
  },
  ["lukas-reineke/cmp-under-comparator"] = { after = "nvim-cmp" },
  ["saadparwaiz1/cmp_luasnip"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-nvim-lsp"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-nvim-lua"] = { after = "nvim-cmp" },
  ["andersevenrud/cmp-tmux"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-path"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-buffer"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-cmdline"] = { after = "nvim-cmp" },
  ["rcarriga/cmp-dap"] = { after = "nvim-cmp" },

  -- Snippet
  ["L3MON4D3/LuaSnip"] = {
    module = "luasnip",
    wants = "friendly-snippets",
    config = function()
      require "configs.luasnip-config"
    end,
  },
  ["rafamadriz/friendly-snippets"] = { opt = true },

  -- Syntax/Treesitter
  ["nvim-treesitter/nvim-treesitter"] = {
    run = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    cmd = {
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSDisableAll",
      "TSEnableAll",
    },
    config = function()
      require "configs.treesitter"
    end,
  },
  ["JoosepAlviste/nvim-ts-context-commentstring"] = { after = "nvim-treesitter" },
  ["p00f/nvim-ts-rainbow"] = { after = "nvim-treesitter" },
  ["windwp/nvim-ts-autotag"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },
  ["kylechui/nvim-surround"] = {
    after = "nvim-treesitter",
    config = function()
      require "configs.surround"
    end,
  },

  -- Fuzzy Finder/Telescope
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    module = "telescope",
    config = function()
      require "configs.telescope-config"
    end,
  },
  ["nvim-telescope/telescope-fzf-native.nvim"] = { after = "telescope.nvim", run = "make" },
  ["nvim-telescope/telescope-file-browser.nvim"] = { after = "telescope.nvim" },

  -- Color
  ["norcalli/nvim-colorizer.lua"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require "configs.colorizer"
    end,
  },

  -- Colorschemes
  ["navarasu/onedark.nvim"] = {
    config = function()
      require "configs.nvim_onedark"
    end,
  },

  -- Utility
  ["lewis6991/impatient.nvim"] = {},
  ["antoinemadec/FixCursorHold.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      vim.g.cursorhold_updatetime = 100
    end,
  },
  ["famiu/bufdelete.nvim"] = {},
  ["gaborvecsei/memento.nvim"] = {},

  -- Icon
  ["kyazdani42/nvim-web-devicons"] = { event = "VimEnter" },

  -- Debugging
  ["mfussenegger/nvim-dap"] = {
    config = function()
      require "configs.dap-config"
    end,
  },
  ["rcarriga/nvim-dap-ui"] = { after = "nvim-dap" },
  ["theHamsta/nvim-dap-virtual-text"] = { after = "nvim-dap" },

  -- Tabline
  ["akinsho/bufferline.nvim"] = {
    after = "nvim-web-devicons",
    config = function()
      require "configs.bufferline"
    end,
  },

  -- Statusline
  ["feline-nvim/feline.nvim"] = {
    after = "nvim-web-devicons",
    config = function()
      require "configs.feline"
    end,
  },

  -- Startup
  ["goolord/alpha-nvim"] = {
    config = function()
      require "configs.alpha"
    end,
  },

  -- Notify
  ["rcarriga/nvim-notify"] = {
    config = function()
      require "configs.nvim-notify"
    end,
  },

  -- Indentation
  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufRead",
    config = function()
      require "configs.indent-line"
    end,
  },

  -- File Explorer
  ["kyazdani42/nvim-tree.lua"] = {
    event = { "BufRead", "BufNewFile" },
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require "configs.nvim-tree"
    end,
  },
  ["folke/trouble.nvim"] = {
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    event = { "BufRead" },
    config = function()
      require "configs.trouble-config"
    end,
  },
  ["mbbill/undotree"] = {
    event = "BufReadPost",
    cmd = "UndotreeToggle",
  },

  -- Comment
  ["numToStr/Comment.nvim"] = {
    module = { "Comment", "Comment.api" },
    keys = { "gc", "gb", "g<", "g>" },
    config = function()
      require "configs.Comment"
    end,
  },
  ["danymat/neogen"] = {
    module = "neogen",
    config = function()
      require "configs.neogen"
    end,
  },

  -- Terminal
  ["akinsho/toggleterm.nvim"] = {
    cmd = "ToggleTerm",
    module = { "toggleterm", "toggleterm.terminal" },
    config = function()
      require "configs.toggleterm"
    end,
  },

  -- Project
  ["ahmedkhalf/project.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require "configs.project"
    end,
  },
  ["nvim-pack/nvim-spectre"] = {
    opt = true,
    config = function()
      require "configs.spectre-config"
    end,
  },

  -- Session
  ["Shatur/neovim-session-manager"] = {
    module = "session_manager",
    cmd = "SessionManager",
    event = "BufWritePost",
    config = function()
      require "configs.session_manager"
    end,
  },

  -- Quickfix
  ["kevinhwang91/nvim-bqf"] = {
    ft = "qf",
    config = function()
      require "configs.bqf"
    end,
  },

  -- Git
  ["tpope/vim-fugitive"] = {
    opt = true,
    cmd = { "Git" },
  },
  ["lewis6991/gitsigns.nvim"] = {
    event = "BufEnter",
    config = function()
      require "configs.gitsigns-config"
    end,
  },
  ["sindrets/diffview.nvim"] = {
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    config = function()
      require "configs.diffview-config"
    end,
  },
  ["TimUntersberger/neogit"] = {
    cmd = "Neogit",
    config = function()
      require "configs.neogit"
    end,
    requires = "nvim-lua/plenary.nvim",
  },

  -- Editing Support
  ["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    config = function()
      require "configs.autopairs"
    end,
  },
  ["ethanholz/nvim-lastplace"] = {
    event = "BufRead",
    config = function()
      require "configs.nvim-lastplace"
    end,
  },
  ["rlue/vim-barbaric"] = { event = { "BufRead", "BufNewFile" } },

  -- Motion
  ["phaazon/hop.nvim"] = {
    event = { "BufNewFile", "BufReadPost" },
    branch = "v1",
    config = function()
      require "configs.hop-config"
    end,
  },

  -- Keybinding
  ["folke/which-key.nvim"] = {
    module = "which-key",
    config = function()
      require "configs.which-key"
    end,
  },

  -- Tmux
  ["aserowy/tmux.nvim"] = {
    event = "BufRead",
    config = function()
      require "configs.tmux-config"
    end,
  },

  -- Filetype
  ["mfussenegger/nvim-jdtls"] = {
    ft = "java",
  },
  ["simrat39/rust-tools.nvim"] = {
    ft = "rust",
    branch = "modularize_and_inlay_rewrite",
  },
  ["Saecki/crates.nvim"] = {
    event = { "BufRead Cargo.toml" },
    config = function()
      require "configs.crates-config"
    end,
  },
  ["iamcco/markdown-preview.nvim"] = {
    ft = "markdown",
    run = "cd app && yarn install",
  },
  ["solarnz/thrift.vim"] = {
    ft = "thrift",
  },
  ["chrisbra/csv.vim"] = {
    ft = "csv",
  },
  ["nanotee/sqls.nvim"] = {
    ft = { "sql", "mysql" },
  },
}

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

local packer = initialize_packer()
packer.startup {
  function(use)
    for key, plugin in pairs(plugins) do
      if type(key) == "string" and not plugin[1] then
        plugin[1] = key
      end
      use(plugin)
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
  },
}
