vim.g.mapleader = " "
vim.api.nvim_set_keymap("", " ", "", {noremap = true, silent = true})

local bind = require("kit.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

-- default map
local def_map = {
    -- Better save
    ["n|<C-s>"]  = map_cu("write"):with_noremap(),

    -- Better window navigation
    ["n|<C-h>"]  = map_cmd("<C-w>h"):with_noremap(),
    ["n|<C-l>"]  = map_cmd("<C-w>l"):with_noremap(),
    ["n|<C-j>"]  = map_cmd("<C-w>j"):with_noremap(),
    ["n|<C-k>"]  = map_cmd("<C-w>k"):with_noremap(),

    -- Insert
    ["i|<C-u>"]  = map_cmd("<C-g>u<C-u>"):with_noremap(),
    ["i|<C-w>"]  = map_cmd("<C-g>u<C-w>"):with_noremap(),

    -- Command line
    ["c|<C-a>"]  = map_cmd("<Home>"):with_noremap(),
    ["c|<C-e>"]  = map_cmd("<End>"):with_noremap(),
    ["c|<C-g>"]  = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),

    -- Visual
    ["v|<C-j>"]  = map_cmd(":m '>+1<cr>gv=gv"),
    ["v|<C-k>"]  = map_cmd(":m '<-2<cr>gv=gv"),
    ["v|<"]      = map_cmd("<gv"),
    ["v|>"]      = map_cmd(">gv"),

    -- nohl
    ["n|<BS>"]   = map_cr("nohlsearch"):with_noremap():with_silent(),
}

bind.nvim_load_mapping(def_map)

local plug_map = {
    -- Format
    ["n|<A-l>"]       = map_cr("Neoformat"):with_noremap():with_silent(),

    -- Plugin nvim-tree
    ["n|<A-1>"]       = map_cr("NvimTreeToggle"):with_noremap():with_silent(),

    -- Bufferline
    ["n|gb"]          = map_cr("BufferLinePick"):with_noremap():with_silent(),
    ["n|<A-j>"]       = map_cr("BufferLineCycleNext"):with_noremap():with_silent(),
    ["n|<A-k>"]       = map_cr("BufferLineCyclePrev"):with_noremap():with_silent(),
    ["n|<A-S-j>"]     = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    ["n|<A-S-k>"]     = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),

    -- Lsp mapp work when insertenter and lsp start
    ["n|ge"]          = map_cr("Lspsaga diagnostic_jump_next"):with_noremap():with_silent(),
    ["n|gE"]          = map_cr("Lspsaga diagnostic_jump_prev"):with_noremap():with_silent(),

    ["n|K"]           = map_cr("Lspsaga hover_doc"):with_noremap():with_silent(),
	["n|<C-Up>"]      = map_cr("lua require('lspsaga.action').smart_scroll_with_saga(-1)"):with_noremap():with_silent(),
	["n|<C-Down>"]    = map_cr("lua require('lspsaga.action').smart_scroll_with_saga(1)"):with_noremap():with_silent(),

    ["n|gs"]          = map_cr("Lspsaga signature_help"):with_noremap():with_silent(),
    ["n|gr"]          = map_cr("Lspsaga rename"):with_noremap():with_silent(),

    ["n|<leader>ga"]  = map_cr("lua require('telescope.builtin').lsp_code_actions{}"):with_noremap():with_silent(),
    ["v|<leader>ga"]  = map_cr("lua require('telescope.builtin').lsp_range_code_actions{}"):with_noremap():with_silent(),
    ["n|<leader>gi"]  = map_cr("lua vim.lsp.buf.incoming_calls()"):with_noremap():with_silent(),
    ["n|<leader>go"]  = map_cr("lua vim.lsp.buf.outgoing_calls()"):with_noremap():with_silent(),

    ["n|gd"]          = map_cr("lua require('telescope.builtin').lsp_definitions{}"):with_noremap():with_silent(),
    ["n|gD"]          = map_cr("lua require('telescope.builtin').lsp_implementations{}"):with_noremap():with_silent(),
    ["n|gh"]          = map_cr("lua require('telescope.builtin').lsp_references{}"):with_noremap():with_silent(),

    -- Plugin Telescope
    ["n|<leader>ft"]  = map_cr("lua require('telescope.builtin').lsp_document_symbols{}"):with_noremap():with_silent(),
    ["n|<leader>ftw"] = map_cr("lua require('telescope.builtin').lsp_workspace_symbols{}"):with_noremap():with_silent(),

    ["n|<leader>fp"]  = map_cr("lua require('telescope').extensions.project.project{}"):with_noremap():with_silent(),
    ["n|<leader>ff"]  = map_cr("lua require('telescope.builtin').find_files{}"):with_noremap():with_silent(),
    ["n|<leader>fg"]  = map_cr("lua require('telescope.builtin').live_grep{}"):with_noremap():with_silent(),
    ["n|<leader>fm"]  = map_cr("lua require('telescope.builtin').marks{}"):with_noremap():with_silent(),
    ["n|<leader>fb"]  = map_cr("lua require('telescope').extensions.file_browser.file_browser()"):with_noremap():with_silent(),
    ["n|<leader>fc"]  = map_cr("lua require('telescope.builtin').current_buffer_fuzzy_find{}"):with_noremap():with_silent(),
    ["n|<leader>fn"]  = map_cr("ene"):with_noremap():with_silent(),

    -- Plugin Aerial
    ["n|<A-7>"]       = map_cr("AerialToggle! right"):with_noremap():with_silent(),

    -- Plugin MarkdownPreview
    ["n|<F12>"]       = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent(),

    -- Plugin dap
    ["n|<F5>"]        = map_cr("lua require('dap').continue()"):with_noremap():with_silent(),
    ["n|<F6>"]        = map_cr("lua require('dap').toggle_breakpoint()"):with_noremap():with_silent(),
    ["n|<F18>"]       = map_cr("lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))"):with_noremap():with_silent(), -- <S-F6>
    ["n|<F8>"]        = map_cr("lua require('dap').step_over()"):with_noremap():with_silent(),
    ["n|<F7>"]        = map_cr("lua require('dap').step_into()"):with_noremap():with_silent(),
    ["n|<F20>"]       = map_cr("lua require('dap').step_out()"):with_noremap():with_silent(), -- <S-F8>

    ["n|<leader>dl"]  = map_cr("Telescope dap commands"):with_noremap():with_silent(),

    -- tsht
    ["o|m"]           = map_cu([[lua require('tsht').nodes()]]):with_silent(),
    ["v|m"]           = map_cr([[lua require('tsht').nodes()]]):with_noremap():with_silent(),
}

bind.nvim_load_mapping(plug_map)
