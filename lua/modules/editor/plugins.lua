local editor = {}
local conf = require("modules.editor.config")

editor["junegunn/vim-easy-align"] = {opt = true, cmd = "EasyAlign"}
editor["itchyny/vim-cursorword"] = {
    opt = true,
    event = {"BufReadPre", "BufNewFile"},
    config = conf.vim_cursorwod
}
editor["terrortylor/nvim-comment"] = {
    opt = true,
    event = "BufEnter",
    config = function()
        require("nvim_comment").setup({
            comment_empty = false,
            hook = function() require("ts_context_commentstring.internal").update_commentstring() end
        })
    end
}
editor["nvim-treesitter/nvim-treesitter"] = {
    opt = true,
    run = ":TSUpdate",
    event = "BufRead",
    config = conf.nvim_treesitter
}
editor["nvim-treesitter/nvim-treesitter-textobjects"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["romgrk/nvim-treesitter-context"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["p00f/nvim-ts-rainbow"] = {
    opt = true,
    after = "nvim-treesitter",
    event = "BufRead"
}
editor["JoosepAlviste/nvim-ts-context-commentstring"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["mfussenegger/nvim-ts-hint-textobject"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["SmiteshP/nvim-gps"] = {
    opt = true,
    after = "nvim-treesitter",
    config = conf.nvim_gps
}
editor["sbdchd/neoformat"] = {opt = true, cmd = "Neoformat"}
editor["windwp/nvim-ts-autotag"] = {
    opt = true,
    ft = {"html", "xml"},
    config = conf.autotag
}
editor["andymass/vim-matchup"] = {
    opt = true,
    after = "nvim-treesitter",
    config = conf.matchup
}
editor["romainl/vim-cool"] = {
    opt = true,
    event = {"CursorMoved", "InsertEnter"}
}
editor["phaazon/hop.nvim"] = {
	opt = true,
	branch = "v1",
	cmd = { "HopLine", "HopLineStart", "HopWord", "HopPattern", "HopChar1", "HopChar2", },
	config = function() require("hop").setup({ keys = "etovxqpdygfblzhckisuran" }) end,
}
editor['rlane/pounce.nvim'] = {
    opt = true,
    cmd = {"Pounce"},
    config = function()
        require("pounce").setup {
            accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
            debug = false,
        }
    end
}
editor["karb94/neoscroll.nvim"] = {
    opt = true,
    event = "WinScrolled",
    config = conf.neoscroll
}
editor["akinsho/nvim-toggleterm.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.toggleterm
}
editor["norcalli/nvim-colorizer.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.nvim_colorizer
}
editor["mfussenegger/nvim-dap"] = {
    opt = false,
    config = conf.dap
}
editor["rcarriga/nvim-dap-ui"] = {
    opt = true,
    config = conf.dapui,
}
editor["theHamsta/nvim-dap-virtual-text"] = {
    opt = true,
    config = function()
        require("nvim-dap-virtual-text").setup()
    end,
}
editor["tpope/vim-fugitive"] = {opt = true, event = "BufRead"}
editor["famiu/bufdelete.nvim"] = {
    opt = true,
    cmd = {"Bdelete", "Bwipeout", "Bdelete!", "Bwipeout!"}
}
editor["chentau/marks.nvim"] = {
    opt = true,
    event = "BufReadPost",
    config = conf.marks
}
editor["rlue/vim-barbaric"] = { opt = false }
editor["christoomey/vim-tmux-navigator"] = {
    opt = false,
    config = conf.tmuxnavigator
}

return editor
