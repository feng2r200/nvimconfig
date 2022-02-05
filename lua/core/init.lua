local vim = vim

local built_ins_config = function()
    vim.g.did_load_filetypes = 1
    vim.g.did_load_fzf = 1
    vim.g.did_load_gtags = 1
    vim.g.did_load_gzip = 1
    vim.g.did_load_tar = 1
    vim.g.did_load_tarPlugin = 1
    vim.g.did_load_zip = 1
    vim.g.did_load_zipPlugin = 1
    vim.g.did_load_getscript = 1
    vim.g.did_load_getscriptPlugin = 1
    vim.g.did_load_vimball = 1
    vim.g.did_load_vimballPlugin = 1
    vim.g.did_load_matchit = 1
    vim.g.did_load_matchparen = 1
    vim.g.did_load_2html_plugin = 1
    vim.g.did_load_logiPat = 1
    vim.g.did_load_rrhelper = 1
    vim.g.did_load_netrw = 1
    vim.g.did_load_netrwPlugin = 1
    vim.g.did_load_netrwSettings = 1
    vim.g.did_load_netrwFileHandlers = 1

    vim.g.loaded_python_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_ruby_provider = 0
end

local leader_map = function()
    vim.g.mapleader = " "
    vim.api.nvim_set_keymap("n", " ", "", {noremap = true})
    vim.api.nvim_set_keymap("x", " ", "", {noremap = true})
end

local load_core = function()
    local pack = require("core.pack")

    built_ins_config()
    leader_map()

    pack.ensure_plugins()

    require("core.global")
    require("core.options")
    require("core.mapping")
    require("core.event")

    pack.load_compile()

    require("keymap")

    vim.cmd [[colorscheme edge]]
end

if vim.g.neovide then
    vim.g.neovide_refresh_rate=140
    vim.g.neovide_transparency=0.8
    vim.g.neovide_input_use_logo=true
    vim.g.neovide_cursor_antialiasing=false
end

load_core()

