local tools = {}
local conf = require("modules.tools.config")

tools["nvim-lua/plenary.nvim"] = {opt = false}
tools["nvim-telescope/telescope.nvim"] = {
    opt = true,
    module = "telescope",
    cmd = "Telescope",
    config = conf.telescope,
    requires = {
        { "nvim-lua/plenary.nvim", opt = false },
        { "nvim-lua/popup.nvim", opt = true },
    },
}
tools["nvim-telescope/telescope-fzf-native.nvim"] = {
    opt = true,
    run = "make",
    after = "telescope.nvim",
}
tools["nvim-telescope/telescope-file-browser.nvim"] = { opt = true, after = "telescope.nvim" }
tools["nvim-telescope/telescope-project.nvim"] = { opt = true, after = "telescope.nvim" }
tools["nvim-telescope/telescope-frecency.nvim"] = {
    opt = true,
    after = "telescope.nvim",
    requires = {{"tami5/sqlite.lua", opt = true}}
}
tools["jvgrootveld/telescope-zoxide"] = { opt = true, after = "telescope.nvim" }
tools["nvim-telescope/telescope-media-files.nvim"] = { opt = true, after = "telescope.nvim" }
tools["nvim-telescope/telescope-dap.nvim"] = { opt = true, after = "telescope.nvim" }
tools["nvim-telescope/telescope-ui-select.nvim"] = { opt = true, after = "telescope.nvim" }

tools["folke/which-key.nvim"] = {
    opt = true,
    keys = ",",
    config = function() require("which-key").setup {} end
}
tools["folke/trouble.nvim"] = {
    opt = true,
    cmd = {"Trouble", "TroubleToggle", "TroubleRefresh"},
    config = conf.trouble
}
tools["gelguy/wilder.nvim"] = {
    event = "CmdlineEnter",
    config = conf.wilder,
    requires = {{"romgrk/fzy-lua-native", after = "wilder.nvim"}}
}
tools["nathom/filetype.nvim"] = {
	opt = false,
	config = conf.filetype,
}

return tools
