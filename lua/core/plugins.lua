local M = {}

local conf = require("modules")

M["kyazdani42/nvim-web-devicons"] = {opt = false}
M["navarasu/onedark.nvim"] = {opt = false, config = conf.ui.onedark}
M["hoob3rt/lualine.nvim"] = {
    opt = true,
    after = "lualine-lsp-progress",
    config = conf.ui.lualine,
}
M["arkav/lualine-lsp-progress"] = {opt = true, after = "nvim-gps"}
M[ "goolord/alpha-nvim"] = {
    opt = true,
    event = "BufWinEnter",
    config = conf.ui.alpha,
}
M["kyazdani42/nvim-tree.lua"] = {
    opt = true,
    cmd = {"NvimTreeToggle", "NvimTreeOpen"},
    config = conf.ui.nvim_tree,
}
M["lewis6991/gitsigns.nvim"] = {
    opt = true,
    event = {"BufRead", "BufNewFile"},
    config = conf.ui.gitsigns,
}
M["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    event = "BufRead",
    config = conf.ui.indent_blankline
}
M["akinsho/bufferline.nvim"] = {
    opt = true,
    event = "BufRead",
    config = conf.ui.nvim_bufferline
}
M["mbbill/undotree"] = {
	opt = true,
	cmd = "UndotreeToggle",
}
M["folke/todo-comments.nvim"] = {
    opt = true,
    event = {"BufRead", "BufNewFile"},
    config = conf.ui.todo_comments
}

M["nvim-lua/plenary.nvim"] = {opt = false}
M["nvim-lua/popup.nvim"] = {opt = false}
M["nvim-telescope/telescope.nvim"] = {
    opt = true,
    module = "telescope",
    cmd = "Telescope",
    config = conf.tool.telescope,
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
    config = conf.tool.trouble
}
M["nathom/filetype.nvim"] = {
    opt = false,
    config = conf.tool.filetype,
}
M["rmagatti/auto-session"] = {
    opt = false,
    config = function()
        require("auto-session").setup({
            log_level = "info",
            auto_session_enable_last_session = true,
            auto_session_enabled = true,
            auto_save_enabled = true,
            auto_restore_enabled = true,
        })
    end
}

M["nvim-treesitter/nvim-treesitter"] = {
    opt = true,
    run = ":TSUpdate",
    event = "BufRead",
    config = conf.editor.nvim_treesitter
}
M["junegunn/vim-easy-align"] = {opt = true, cmd = "EasyAlign"}
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
M["JoosepAlviste/nvim-ts-context-commentstring"] = {
    opt = true,
    after = "nvim-treesitter"
}
M["nvim-treesitter/nvim-treesitter-textobjects"] = {
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
    config = conf.editor.nvim_gps
}
M["sbdchd/neoformat"] = {opt = true, cmd = "Neoformat"}
M["windwp/nvim-ts-autotag"] = {
    opt = true,
    ft = {"html", "xml"},
    config = conf.editor.autotag
}
M["andymass/vim-matchup"] = {
    opt = true,
    after = "nvim-treesitter",
    config = function() vim.cmd([[let g:matchup_matchparen_offscreen = {'method': 'popup'}]]) end
}
M["karb94/neoscroll.nvim"] = {
    opt = true,
    event = "WinScrolled",
    config = conf.editor.neoscroll
}
M["akinsho/nvim-toggleterm.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.editor.toggleterm
}
M["norcalli/nvim-colorizer.lua"] = {
    opt = true,
    event = "BufRead",
    config = function () require("colorizer").setup() end
}
M["mfussenegger/nvim-dap"] = {
    config = conf.editor.dap
}
M["rcarriga/nvim-dap-ui"] = {
    config = conf.editor.dapui,
}
M["theHamsta/nvim-dap-virtual-text"] = {
    opt = true,
}
M["tpope/vim-fugitive"] = {opt = true, event = "BufRead"}
M["sindrets/diffview.nvim"] = {
	opt = true,
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh", "DiffviewFileHistory" },
}
M["famiu/bufdelete.nvim"] = {
	opt = true,
	cmd = { "Bdelete", "Bwipeout", "Bdelete!", "Bwipeout!" },
}
M["phaazon/hop.nvim"] = {
	opt = true,
	branch = "v1",
	cmd = {
		"HopLine",
		"HopLineStart",
		"HopWord",
		"HopPattern",
		"HopChar1",
		"HopChar2",
	},
	config = function()
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
	end,
}
M["ur4ltz/surround.nvim"] = {
    opt = true,
    event = {"BufRead", "BufNewFile"},
    config = conf.editor.surround,
}

M["rlue/vim-barbaric"] = { opt = false }
M["christoomey/vim-tmux-navigator"] = {
    opt = false,
    config = function () vim.g.tmux_navigator_disable_when_zoomed = 1 end
}

M["neovim/nvim-lspconfig"] = {
    opt = true,
    event = "BufReadPre",
    config = conf.completion.nvim_lsp
}
M["williamboman/nvim-lsp-installer"] = {
    opt = true,
    after = "nvim-lspconfig"
}
M["tami5/lspsaga.nvim"] = {
    opt = true,
    after = "nvim-lspconfig",
}
M["stevearc/aerial.nvim"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.completion.aerial,
}
M["ray-x/lsp_signature.nvim"] = {opt = true, after = "nvim-lspconfig"}
M["hrsh7th/nvim-cmp"] = {
    config = conf.completion.cmp,
    event = {"InsertEnter", "CmdlineEnter"},
    requires = {
        {"lukas-reineke/cmp-under-comparator"},
        {"saadparwaiz1/cmp_luasnip", after = "LuaSnip"},
        {"hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip"},
        {"hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp"},
        {"andersevenrud/cmp-tmux", after = "cmp-nvim-lua"},
        {"hrsh7th/cmp-path", after = "cmp-tmux"},
        {"hrsh7th/cmp-buffer", after = "cmp-path"},
        {"hrsh7th/cmp-cmdline", after = "cmp-buffer"},
    }
}
M["L3MON4D3/LuaSnip"] = {
    after = "nvim-cmp",
    config = conf.completion.luasnip,
    requires = "rafamadriz/friendly-snippets"
}
M["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = conf.completion.autopairs
}

M["simrat39/rust-tools.nvim"] = {
    opt = true,
    ft = "rust",
    config = require("modules.lang").rust_tools,
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
