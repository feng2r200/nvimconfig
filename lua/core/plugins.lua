local function echo(messages)
  messages = messages or {{"\n"}}
  if type(messages) == "table" then
    vim.api.nvim_echo(messages, false, {})
  end
end

local plugins = {
  -- Plugin manager
  ["wbthomason/packer.nvim"] = {},

  -- Optimiser
  ["lewis6991/impatient.nvim"] = {},

  -- Lua functions
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  -- Popup API
  ["nvim-lua/popup.nvim"] = {},

  ["navarasu/onedark.nvim"] = {
    config = function()
      require "configs.nvim_onedark"
    end,
  },

  -- Neovim UI Enhancer
  ["MunifTanjim/nui.nvim"] = { module = "nui" },

  -- Cursorhold fix
  ["antoinemadec/FixCursorHold.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      vim.g.cursorhold_updatetime = 100
    end,
  },

  -- FileType
  ["nathom/filetype.nvim"] = {
    event = "BufEnter",
    config = function()
      require "configs.filetype-nvim"
    end,
  },

  -- Icons
  ["kyazdani42/nvim-web-devicons"] = {
    event = "VimEnter",
    config = function()
      require "configs.icons"
    end,
  },

  -- Bufferline
  ["akinsho/bufferline.nvim"] = {
    after = "nvim-web-devicons",
    config = function()
      require "configs.bufferline"
    end,
  },

  -- Better buffer closing
  ["famiu/bufdelete.nvim"] = { cmd = { "Bdelete", "Bwipeout" } },

  -- File explorer
  ["nvim-neo-tree/neo-tree.nvim"] = {
    branch = "v2.x",
    module = "neo-tree",
    cmd = "Neotree",
    requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    setup = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = function()
      require "configs.neo-tree"
    end,
  },

  ["s1n7ax/nvim-window-picker"] = {
    after = "neo-tree.nvim",
    tag = "v1.*",
    config = function()
      require "configs.window-picker"
    end,
  },

  -- Statusline
  ["feline-nvim/feline.nvim"] = {
    after = "nvim-web-devicons",
    config = function()
      require "configs.feline"
    end,
  },

  -- gps
  ["SmiteshP/nvim-navic"] = {
    after = "nvim-web-devicons",
    requires = "neovim/nvim-lspconfig",
    config = function()
      require "configs.gps"
    end,
  },

  -- Autoclose tags
  ["windwp/nvim-ts-autotag"] = { after = "nvim-treesitter" },

  -- Context based commenting
  ["JoosepAlviste/nvim-ts-context-commentstring"] = { after = "nvim-treesitter" },

  ["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },

  ["andymass/vim-matchup"] = {
    after = "nvim-treesitter",
    config = function() vim.cmd([[let g:matchup_matchparen_offscreen = {'method': 'popup'}]]) end
  },

  -- Syntax highlighting
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

  -- Snippet collection
  ["rafamadriz/friendly-snippets"] = { opt = true },

  -- Snippet engine
  ["L3MON4D3/LuaSnip"] = {
    module = "luasnip",
    wants = "friendly-snippets",
    config = function()
      require "configs.luasnip"
    end,
  },

  -- Completion engine
  ["hrsh7th/nvim-cmp"] = {
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require "configs.cmp"
    end,
  },

  ["lukas-reineke/cmp-under-comparator"] = {
    after = "nvim-cmp",
  },
  ["saadparwaiz1/cmp_luasnip"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp",
  },
  ["andersevenrud/cmp-tmux"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-path"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-buffer"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
  },
  ["ray-x/cmp-treesitter"] = {
    after = "nvim-cmp",
  },

  -- Built-in LSP
  ["neovim/nvim-lspconfig"] = { event = "VimEnter" },

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
    end
  },
  ["j-hui/fidget.nvim"] = {
    event = "BufRead",
    after = "nvim-lspconfig",
    config = function()
      require "configs.fidget-config"
    end
  },
  ["nvim-lua/lsp_extensions.nvim"] = {
    event = "BufRead",
    after = "nvim-lspconfig",
  },
  ["christianchiarulli/lsp-inlayhints.nvim"] = {
    event = "BufRead",
    after = "nvim-lspconfig",
    branch = "user-config",
    config = function()
      require "configs.lsp-inlayhints-config"
    end
  },

  -- LSP manager
  ["williamboman/nvim-lsp-installer"] = {
    after = "nvim-lspconfig",
    config = function()
      require "configs.nvim-lsp-installer"
      require "lsp"
    end,
  },

  -- LSP symbols
  ["simrat39/symbols-outline.nvim"] = {
    event = "BufReadPost",
    config = function()
      require "configs.symbols"
    end,
  },

  -- Formatting and linting
  ["jose-elias-alvarez/null-ls.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require "configs.null-ls"
    end,
  },

  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "configs.signature"
    end
  },

  -- Fuzzy finder
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    module = "telescope",
    config = function()
      require "configs.telescope-config"
    end,
  },

  -- Fuzzy finder syntax support
  ["nvim-telescope/telescope-fzf-native.nvim"] = { after = "telescope.nvim", run = "make" },
  ["nvim-telescope/telescope-file-browser.nvim"] = { after = "telescope.nvim" },

  ["ahmedkhalf/project.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require "configs.project"
    end
  },

  -- Git integration
  ["lewis6991/gitsigns.nvim"] = {
    event = "BufEnter",
    config = function()
      require "configs.gitsigns-config"
    end,
  },

  ["sindrets/diffview.nvim"] = {
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh", "DiffviewFileHistory" },
    config = function()
      require "configs.diffview-config"
    end
  },

  -- Color highlighting
  ["norcalli/nvim-colorizer.lua"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require "configs.colorizer"
    end,
  },

  -- Autopairs
  ["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    config = function()
      require "configs.autopairs"
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

  -- Commenting
  ["numToStr/Comment.nvim"] = {
    module = { "Comment", "Comment.api" },
    keys = { "gc", "gb", "g<", "g>" },
    config = function()
      require "configs.Comment"
    end,
  },

  -- Indentation
  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufRead",
    config = function()
      require "configs.indent-line"
    end,
  },

  -- Keymaps popup
  ["folke/which-key.nvim"] = {
    module = "which-key",
    config = function()
      require "configs.which-key"
    end,
  },

  -- Smooth scrolling
  ["declancm/cinnamon.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require "configs.cinnamon"
    end,
  },

  -- Get extra JSON schemas
  ["b0o/SchemaStore.nvim"] = { module = "schemastore" },

  -- Session manager
  ["Shatur/neovim-session-manager"] = {
    module = "session_manager",
    cmd = "SessionManager",
    event = "BufWritePost",
    config = function()
      require "configs.session_manager"
    end,
  },

  -- Tmux
  ["aserowy/tmux.nvim"] = {
    event = "BufRead",
    config = function()
      require "configs.tmux-config"
    end,
  },

  -- EasyAlign
  ["junegunn/vim-easy-align"] = {
    cmd = "EasyAlign",
  },

  -- File types
  ["mfussenegger/nvim-jdtls"] = {
    ft = "java",
  },

  ["chrisbra/csv.vim"] = {
    ft = "csv",
  },

  ["solarnz/thrift.vim"] = {
    ft = "thrift",
  },

  ["christianchiarulli/rust-tools.nvim"] = {
    ft = "rust",
    branch = "modularize_and_inlay_rewrite",
    config = function()
      require "configs.rust-config"
    end
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

  -- Last place
  ["ethanholz/nvim-lastplace"] = {
    event = "BufRead",
    config = function()
      require "configs.nvim-lastplace"
    end,
  },

  -- Search and replace pane
  ["nvim-pack/nvim-spectre"] = {
    opt = true,
    config = function ()
      require "configs.spectre-config"
    end,
  },

  ["phaazon/hop.nvim"] = {
    event = { "BufNewFile", "BufReadPost" },
    branch = "v1",
    config = function()
      require "configs.hop-config"
    end,
  },

  -- Debugger
  ["mfussenegger/nvim-dap"] = {
    config = function()
      require "configs.dap-config"
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    after = "nvim-dap",
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    after = "nvim-dap",
  },

  ["rlue/vim-barbaric"] = {
    event = {"BufRead", "BufNewFile"}
  },

  ["kevinhwang91/nvim-bqf"] = {
    ft = "qf",
    config = function()
      require "configs.bqf"
    end
  },

  ["folke/trouble.nvim"] = {
    cmd = {"Trouble", "TroubleToggle", "TroubleRefresh"},
    event = {"BufRead"},
    config = function()
      require "configs.trouble-config"
    end,
  },

  ["mbbill/undotree"] = {
    event = "BufReadPost",
    cmd = "UndotreeToggle",
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
    echo { { "Initializing Packer...\n\n" } }
    vim.cmd "packadd packer.nvim"
    packer_avail, packer = pcall(require, "packer")
    if not packer_avail then
      vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path .. "\n\n" .. packer)
    end
  end
  return packer
end

local compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua"
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
    compile_path = compile_path,
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
    profile = {
      enable = true,
      threshold = 0.0001,
    },
    git = {
      clone_timeout = 300,
      subcommands = {
        update = "pull --rebase",
      },
    },
    max_jobs = 20,
    auto_clean = true,
    compile_on_sync = true,
  },
}

local M = {}
function M.compiled()
  local run_me, _ = loadfile(compile_path)
  if run_me then
    run_me()
  else
    echo { { "Please run " }, { ":PackerSync", "Title" } }
  end
end

M.compiled()

