local vim = vim

local built_ins_config = function()
    vim.g.loaded_fzf = 1
    vim.g.loaded_gtags = 1
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
    vim.g.loaded_python_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_ruby_provider = 0
end

local leader_map = function()
    vim.g.mapleader = " "
    vim.api.nvim_set_keymap("n", " ", "", {noremap = true})
    vim.api.nvim_set_keymap("x", " ", "", {noremap = true})
end

local neovide_config = function ()
    vim.g.neovide_refresh_rate=140
    vim.g.neovide_transparency=0.8
    vim.g.neovide_input_use_logo=true
    vim.g.neovide_cursor_antialiasing=false
end

local load_core = function()
    local pack = require("core.pack")

    built_ins_config()
    leader_map()

    pack.ensure_plugins()
    neovide_config()

    require("core.global")
    require("core.options")
    require("core.mapping")
    require("core.event")

    pack.load_compile()

    require("keymap")

    vim.cmd [[colorscheme edge]]
end

load_core()
