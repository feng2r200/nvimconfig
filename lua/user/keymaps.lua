vim.g.mapleader = " "
vim.api.nvim_set_keymap("", " ", "<Nop>", {noremap = true, silent = true})

local bind = require("user.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd

-- default map
local def_map = {
    -- Better save
    ["n|<C-s>"]     = map_cr("write"):with_noremap(),
    ["i|<C-s>"]     = map_cmd("<Esc>:write<CR>i"):with_noremap(),

    -- Better window navigation
    ["n|<C-h>"]     = map_cmd("<C-w>h"):with_noremap(),
    ["n|<C-l>"]     = map_cmd("<C-w>l"):with_noremap(),
    ["n|<C-j>"]     = map_cmd("<C-w>j"):with_noremap(),
    ["n|<C-k>"]     = map_cmd("<C-w>k"):with_noremap(),

    ["n|<C-Up>"]    = map_cr("resize -1"):with_noremap(),
    ["n|<C-Down>"]  = map_cr("resize +1"):with_noremap(),
    ["n|<C-Left>"]  = map_cr("vertical resize -1"):with_noremap(),
    ["n|<C-Right>"] = map_cr("vertical resize +1"):with_noremap(),

    -- Insert
    ["i|<C-u>"]     = map_cmd("<C-g>u<C-u>"):with_noremap(),
    ["i|<C-w>"]     = map_cmd("<C-g>u<C-w>"):with_noremap(),

    -- Command line
    ["c|<C-a>"]     = map_cmd("<Home>"):with_noremap(),
    ["c|<C-e>"]     = map_cmd("<End>"):with_noremap(),
    ["c|<C-g>"]     = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),

    -- Visual
    ["v|<C-j>"]     = map_cmd(":m '>+1<cr>gv=gv"),
    ["v|<C-k>"]     = map_cmd(":m '<-2<cr>gv=gv"),
    ["v|<"]         = map_cmd("<gv"),
    ["v|>"]         = map_cmd(">gv"),

    -- nohl
    ["n|<BS>"]      = map_cr("nohlsearch"):with_noremap():with_silent(),

    -- Navigate buffers
    ["n|R"]         = map_cr("BufferLineCycleNext"):with_noremap():with_silent(),
    ["n|E"]         = map_cr("BufferLineCyclePrev"):with_noremap():with_silent(),
    ["n|gR"]        = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    ["n|gE"]        = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),

    ["n|K"]         = map_cr("Lspsaga hover_doc"):with_noremap():with_silent(),

    ["n|gd"]        = map_cr("lua require('telescope.builtin').lsp_definitions{}"):with_noremap():with_silent(),
    ["n|gD"]        = map_cr("lua require('telescope.builtin').lsp_implementations{}"):with_noremap():with_silent(),
    ["n|gh"]        = map_cr("lua require('telescope.builtin').lsp_references{}"):with_noremap():with_silent(),

}

bind.nvim_load_mapping(def_map)

