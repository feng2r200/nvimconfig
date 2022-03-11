local M = {}

local ui_conf = require("modules.ui.config")

M["kyazdani42/nvim-web-devicons"] = {opt = false}
M["navarasu/onedark.nvim"] = {opt = false, config = ui_conf.onedark}
M["hoob3rt/lualine.nvim"] = {
    opt = true,
    after = "lualine-lsp-progress",
    config = ui_conf.lualine,
}
M["arkav/lualine-lsp-progress"] = {opt = true, after = "nvim-gps"}
M[ "goolord/alpha-nvim"] = {
    opt = true,
    event = "BufWinEnter",
    config = ui_conf.alpha,
}
M["kyazdani42/nvim-tree.lua"] = {
    opt = true,
    cmd = {"NvimTreeToggle", "NvimTreeOpen"},
    config = ui_conf.nvim_tree,
}
M["lewis6991/gitsigns.nvim"] = {
    opt = true,
    event = {"BufRead", "BufNewFile"},
    config = ui_conf.gitsigns,
}
M["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    event = "BufRead",
    config = ui_conf.indent_blankline
}
M["akinsho/nvim-bufferline.lua"] = {
    opt = true,
    event = "BufRead",
    config = ui_conf.nvim_bufferline
}

local tool_conf = require("modules.tools.config")
M["nvim-lua/plenary.nvim"] = {opt = false}
M["nvim-lua/popup.nvim"] = {opt = false}
M["nvim-telescope/telescope.nvim"] = {
    opt = true,
    module = "telescope",
    cmd = "Telescope",
    config = tool_conf.telescope,
}
M["nvim-telescope/telescope-fzf-native.nvim"] = { opt = true, run = "make", after = "telescope.nvim", }
M["nvim-telescope/telescope-file-browser.nvim"] = { opt = true, after = "telescope.nvim" }
M["nvim-telescope/telescope-project.nvim"] = { opt = true, after = "telescope.nvim" }
M["nvim-telescope/telescope-media-files.nvim"] = { opt = true, after = "telescope.nvim" }
M["nvim-telescope/telescope-dap.nvim"] = { opt = true, after = "telescope.nvim" }
M["nvim-telescope/telescope-ui-select.nvim"] = { opt = true, after = "telescope.nvim" }
M["folke/which-key.nvim"] = {
    opt = true,
    keys = ",",
    config = function() require("which-key").setup {} end
}
M["folke/trouble.nvim"] = {
    opt = true,
    cmd = {"Trouble", "TroubleToggle", "TroubleRefresh"},
    config = tool_conf.trouble
}
M["gelguy/wilder.nvim"] = {
    opt = true,
    event = "CmdlineEnter",
    config = tool_conf.wilder,
}
M["romgrk/fzy-lua-native"] = { opt = true, after = "wilder.nvim"}
M["nathom/filetype.nvim"] = {
	opt = false,
	config = tool_conf.filetype,
}

local editor_conf = require("modules.editor.config")

M["junegunn/vim-easy-align"] = {opt = true, cmd = "EasyAlign"}
M["itchyny/vim-cursorword"] = {
    opt = true,
    event = {"BufReadPre", "BufNewFile"},
    config = editor_conf.vim_cursorwod
}
M["terrortylor/nvim-comment"] = {
    opt = true,
    event = "BufEnter",
    config = function()
        require("nvim_comment").setup({
            comment_empty = false,
            hook = function() require("ts_context_commentstring.internal").update_commentstring() end
        })
    end
}
M["nvim-treesitter/nvim-treesitter"] = {
    opt = true,
    run = ":TSUpdate",
    event = "BufRead",
    config = editor_conf.nvim_treesitter
}
M["nvim-treesitter/nvim-treesitter-textobjects"] = {
    opt = true,
    after = "nvim-treesitter"
}
M["romgrk/nvim-treesitter-context"] = {
    opt = true,
    after = "nvim-treesitter"
}
M["p00f/nvim-ts-rainbow"] = {
    opt = true,
    after = "nvim-treesitter",
    event = "BufRead"
}
M["JoosepAlviste/nvim-ts-context-commentstring"] = {
    opt = true,
    after = "nvim-treesitter"
}
M["mfussenegger/nvim-ts-hint-textobject"] = {
    opt = true,
    after = "nvim-treesitter"
}
M["SmiteshP/nvim-gps"] = {
    opt = true,
    after = "nvim-treesitter",
    config = editor_conf.nvim_gps
}
M["sbdchd/neoformat"] = {opt = true, cmd = "Neoformat"}
M["windwp/nvim-ts-autotag"] = {
    opt = true,
    ft = {"html", "xml"},
    config = editor_conf.autotag
}
M["andymass/vim-matchup"] = {
    opt = true,
    after = "nvim-treesitter",
    config = editor_conf.matchup
}
M["romainl/vim-cool"] = {
    opt = true,
    event = {"CursorMoved", "InsertEnter"}
}
M["phaazon/hop.nvim"] = {
	opt = true,
	branch = "v1",
	cmd = { "HopLine", "HopLineStart", "HopWord", "HopPattern", "HopChar1", "HopChar2", },
	config = function() require("hop").setup({ keys = "etovxqpdygfblzhckisuran" }) end,
}
M['rlane/pounce.nvim'] = {
    opt = true,
    cmd = {"Pounce"},
    config = function()
        require("pounce").setup {
            accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
            debug = false,
        }
    end
}
M["karb94/neoscroll.nvim"] = {
    opt = true,
    event = "WinScrolled",
    config = editor_conf.neoscroll
}
M["akinsho/nvim-toggleterm.lua"] = {
    opt = true,
    event = "BufRead",
    config = editor_conf.toggleterm
}
M["norcalli/nvim-colorizer.lua"] = {
    opt = true,
    event = "BufRead",
    config = editor_conf.nvim_colorizer
}
M["mfussenegger/nvim-dap"] = {
    opt = false,
    config = editor_conf.dap
}
M["rcarriga/nvim-dap-ui"] = {
    opt = true,
    config = editor_conf.dapui,
}
M["theHamsta/nvim-dap-virtual-text"] = {
    opt = true,
    config = function()
        require("nvim-dap-virtual-text").setup()
    end,
}
M["tpope/vim-fugitive"] = {opt = true, event = "BufRead"}
M["famiu/bufdelete.nvim"] = {
    opt = true,
    cmd = {"Bdelete", "Bwipeout", "Bdelete!", "Bwipeout!"}
}
M["chentau/marks.nvim"] = {
    opt = true,
    event = "BufReadPost",
    config = editor_conf.marks
}
M["rlue/vim-barbaric"] = { opt = false }
M["christoomey/vim-tmux-navigator"] = {
    opt = false,
    config = editor_conf.tmuxnavigator
}

local completion_conf = require("modules.completion.config")

M["neovim/nvim-lspconfig"] = {
    opt = true,
    event = "BufReadPre",
    config = completion_conf.nvim_lsp
}
M["williamboman/nvim-lsp-installer"] = {
    opt = true,
    after = "nvim-lspconfig"
}
M["stevearc/aerial.nvim"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = completion_conf.aerial,
}
M["ray-x/lsp_signature.nvim"] = {opt = true, after = "nvim-lspconfig"}
M["hrsh7th/nvim-cmp"] = {
    config = completion_conf.cmp,
    event = "InsertEnter",
    requires = {
        {"lukas-reineke/cmp-under-comparator"},
        {"saadparwaiz1/cmp_luasnip", after = "LuaSnip"},
        {"hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip"},
        {"hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp"},
        {"andersevenrud/cmp-tmux", after = "cmp-nvim-lua"},
        {"hrsh7th/cmp-path", after = "cmp-tmux"},
        {"hrsh7th/cmp-buffer", after = "cmp-path"},
    }
}
M["L3MON4D3/LuaSnip"] = {
    after = "nvim-cmp",
    config = completion_conf.luasnip,
    requires = "rafamadriz/friendly-snippets"
}
M["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = completion_conf.autopairs
}

M["simrat39/rust-tools.nvim"] = {
    opt = true,
    ft = "rust",
    config = require("modules.lang.config").rust_tools,
}
M["mfussenegger/nvim-jdtls"] = {
    opt = true,
    ft = "java",
}
M["iamcco/markdown-preview.nvim"] = {
    opt = true,
    ft = "markdown",
    run = "cd app && yarn install"
}
M["chrisbra/csv.vim"] = {opt = true, ft = "csv"}

return M
