local vim = vim

local built_ins_config = function()
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
    vim.g.did_load_filetypes = 1
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
    built_ins_config()
    leader_map()

    require("core.global")
    require("core.options")
    require("core.mapping")
    require("core.event")

    local pack = require("core.pack")
    pack.ensure_plugins()
    pack.load_compile()

    require("keymap")

    vim.cmd [[colorscheme edge]]
end

load_core()
