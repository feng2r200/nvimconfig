local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

local plug_map = {
    -- Neoformat
    ["n|<C-A-l>"]    = map_cu("FormatWrite"):with_noremap():with_silent(),

    -- Bufferline
    ["n|gb"]         = map_cr("BufferLinePick"):with_noremap():with_silent(),
    ["n|<A-j>"]      = map_cr("BufferLineCycleNext"):with_noremap():with_silent(),
    ["n|<A-k>"]      = map_cr("BufferLineCyclePrev"):with_noremap():with_silent(),
    ["n|<A-S-j>"]    = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    ["n|<A-S-k>"]    = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),

    -- Lsp mapp work when insertenter and lsp start
    ["n|ge"]         = map_cr("lua vim.lsp.diagnostic.goto_next()"):with_noremap():with_silent(),
    ["n|gE"]         = map_cr("lua vim.lsp.diagnostic.goto_prev()"):with_noremap():with_silent(),
    ["n|K"]          = map_cr("lua vim.lsp.buf.hover()"):with_noremap():with_silent(),
    ["n|gs"]         = map_cr("lua vim.lsp.buf.signature_help()"):with_noremap():with_silent(),
    ["n|gr"]         = map_cr("lua vim.lsp.buf.rename()"):with_noremap():with_silent(),

    -- Plugin nvim-tree
    ["n|<A-1>"]      = map_cr("NvimTreeToggle"):with_noremap():with_silent(),

    -- Plugin Telescope
    ["n|<C-F13>"]    = map_cu("Telescope commands"):with_noremap():with_silent(), -- cmd + shift + p
    ["n|<C-F14>"]    = map_cu("Telescope"):with_noremap():with_silent(), -- cmd + p

    ["n|gd"]         = map_cr("Telescope lsp_definitions"):with_noremap():with_silent(),
    ["n|gD"]         = map_cr("Telescope lsp_implementations"):with_noremap():with_silent(),
    ["n|gh"]         = map_cr("Telescope lsp_references"):with_noremap():with_silent(),

    ["n|<Leader>fp"] = map_cu("lua require('telescope').extensions.project.project{}"):with_noremap():with_silent(),
    ["n|<Leader>fe"] = map_cu("lua require('telescope').extensions.frecency.frecency{}"):with_noremap():with_silent(),
    ["n|<Leader>ff"] = map_cu("Telescope find_files"):with_noremap():with_silent(),
    ["n|<Leader>fg"] = map_cu("Telescope live_grep"):with_noremap():with_silent(),
    ["n|<Leader>fm"] = map_cu("Telescope marks"):with_noremap():with_silent(),
    ["n|<Leader>fb"] = map_cu("Telescope file_browser"):with_noremap():with_silent(),
    ["n|<Leader>fz"] = map_cu("Telescope zoxide list"):with_noremap():with_silent(),

    ["n|<leader>fa"] = map_cu("Telescope lsp_code_actions"):with_noremap():with_silent(),
    ["v|<leader>fa"] = map_cr("Telescope lsp_range_code_actions"):with_noremap():with_silent(),

    ["n|<leader>fd"] = map_cr("Telescope diagnostics bufnr=0"):with_noremap():with_silent(),
    ["n|<leader>fwd"] = map_cr("Telescope diagnostics"):with_noremap():with_silent(),

    ["n|<leader>ftd"] = map_cr("Telescope lsp_document_symbols"):with_noremap():with_silent(),
    ["n|<leader>ftw"] = map_cr("Telescope lsp_workspace_symbols"):with_noremap():with_silent(),

    -- Plugin Hop
    ["n|<leader>w"]  = map_cu("HopWord"):with_noremap(),
    ["n|<leader>j"]  = map_cu("HopLine"):with_noremap(),
    ["n|<leader>k"]  = map_cu("HopLine"):with_noremap(),
    ["n|<leader>c"]  = map_cu("HopChar1"):with_noremap(),
    ["n|<leader>cc"] = map_cu("HopChar2"):with_noremap(),

    -- Plugin SymbolOutline
    ["n|<A-7>"]      = map_cr("SymbolsOutline"):with_noremap():with_silent(),

    -- Plugin MarkdownPreview
    ["n|<F12>"]      = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent(),

    -- Plugin auto_session
    ["n|<leader>ss"] = map_cu("SaveSession"):with_noremap():with_silent(),
    ["n|<leader>sr"] = map_cu("RestoreSession"):with_noremap():with_silent(),
    ["n|<leader>sd"] = map_cu("DeleteSession"):with_noremap():with_silent(),

    -- Plugin SnipRun
    ["v|<leader>r"]  = map_cr("SnipRun"):with_noremap():with_silent(),

    -- Plugin dap
    ["n|<F6>"]       = map_cr("lua require('dap').toggle_breakpoint()"):with_noremap():with_silent(),
    ["n|<F18>"]      = map_cr("lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))"):with_noremap():with_silent(), -- <S-F6>
    ["n|<F8>"]       = map_cr("lua require('dap').step_over()"):with_noremap():with_silent(),
    ["n|<F7>"]       = map_cr("lua require('dap').step_into()"):with_noremap():with_silent(),
    ["n|<F20>"]      = map_cr("lua require('dap').step_out()"):with_noremap():with_silent(), -- <S-F8>
    ["n|<leader>dl"] = map_cr("Telescope dap commands"):with_noremap():with_silent(),
    ["n|<leader>do"] = map_cr("lua require('dap').repl.open()"):with_noremap():with_silent(),

    -- tsht
    ["o|m"] = map_cu([[lua require('tsht').nodes()]]):with_silent(),
    ["v|m"] = map_cr([[lua require('tsht').nodes()]]):with_noremap():with_silent(),
};

bind.nvim_load_mapping(plug_map)
