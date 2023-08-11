local map = vim.keymap.set
local default_options = { silent = true }

map("", "<Space>", "<Nop>", {})

map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)

map("x", "<C-j>", ":m'>+1<cr>gv-gv", default_options)
map("x", "<C-k>", ":m'<-2<cr>gv-gv", default_options)

map("n", "<BS>", ":nohlsearch<Bar>:echo<CR>", default_options)

map("n", "<C-h>", function() require("tmux").move_left() end, default_options)
map("n", "<C-j>", function() require("tmux").move_bottom() end, default_options)
map("n", "<C-k>", function() require("tmux").move_top() end, default_options)
map("n", "<C-l>", function() require("tmux").move_right() end, default_options)

map("n", "<M-h>", function() require("tmux").resize_left() end, default_options)
map("n", "<M-j>", function() require("tmux").resize_bottom() end, default_options)
map("n", "<M-k>", function() require("tmux").resize_top() end, default_options)
map("n", "<M-l>", function() require("tmux").resize_right() end, default_options)

map("n", "<C-t>", "<cmd>ToggleTerm<cr>", default_options)

map("n", "K", function() require("user.core.lsp").code_hover() end, default_options)
map("n", "R", function() vim.lsp.buf.rename() end, default_options)

map("n", "<F4>", function() require("dap").terminate() end, default_options)
map("n", "<F5>", function() require("dap").continue() end, default_options)
map("n", "<F8>", function() require("dap").step_over() end, default_options)
map("n", "<F7>", function() require("dap").step_into() end, default_options)
map("n", "<F9>", function() require("dap").step_out() end, default_options)

-- enhance f motion
map("n", "<Space>f", function() require("hop").hint_char1 { direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true } end, default_options)
map("n", "<Space>F", function() require("hop").hint_char1 { direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true } end, default_options)
map("o", "<Space>f", function() require("hop").hint_char1 { direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true, } end, default_options)
map("o", "<Space>F", function() require("hop").hint_char1 { direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true, } end, default_options)
map("", "<Space>t", function() require("hop").hint_char1 { direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true } end, default_options)
map("", "<Space>T", function() require("hop").hint_char1 { direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true } end, default_options)

local wk = require "which-key"

wk.register({
  ["]b"] = { "<cmd>BufferLineCycleNext<cr>", "BufferLineCycleNext" },
  ["[b"] = { "<cmd>BufferLineCyclePrev<cr>", "BufferLineCyclePrev" },
  [">b"] = { "<cmd>BufferLineMoveNext<cr>", "BufferLineMoveNext" },
  ["<b"] = { "<cmd>BufferLineMovePrev<cr>", "BufferLineMovePrev" },

  ["gd"] = { function() require("telescope.builtin").lsp_definitions {} end, "Show the definition of current symbol" },
  ["gy"] = { function() require("telescope.builtin").lsp_type_definitions {} end, "Declaration of current symbol" },
  ["gh"] = { function() require("telescope.builtin").lsp_references {} end, "Search references" },
  ["gi"] = { function() require("telescope.builtin").lsp_implementations {} end, "Implementation of current symbol" },
  ["gs"] = { function() vim.lsp.buf.signature_help() end, "Signature help" },

  ["[d"] = { function() vim.diagnostic.goto_prev() end, "Previous diagnostic" },
  ["]d"] = { function() vim.diagnostic.goto_next() end, "Next diagnostic" },
  ["gl"] = { function() vim.diagnostic.open_float() end, "Hover diagnostics" },

  g = {
    a = {
      name = "Align",
      w = { function() local a = require "align"; a.operator(a.align_to_string, { is_pattern = false, reverse = true, preview = true }) end, "Align a paragraph to string" },
      a = { function() local a = require "align"; a.operator(a.align_to_char, { reverse = true }) end, "Align a paragraph to char" },
    },
  },
}, { mode = "n", default_options })

wk.register({
  a = {
    name = "Align",
    a = { function() require("align").align_to_char(1, true) end, "Align to char" },
    s = { function() require("align").align_to_char(2, true, true) end, "Align to chars" },
    w = { function() require("align").align_to_string(false, true, true) end, "Align to string" },
    r = { function() require("align").align_to_string(true, true, true) end, "Align to pattern" },
  },
}, { mode = "x", default_options})

wk.register({
  ["<tab>"] = { "<cmd>e#<cr>", "Prev buffer" },
  b = { function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown { previewer = false }) end, "Search buffers" },
  j = { "<cmd>HopLine<cr>", "Hop line" },
  k = { "<cmd>HopLine<cr>", "Hop line" },
  w = { "<cmd>HopWord<cr>", "Hop word" },
  s = { "<cmd>HopChar1<cr>", "Hop char1" },
}, { prefix = "<Space>", mode = "n", default_options })

wk.register({
  d = {
    name = "Debug",
    b = { function() require("dap").toggle_breakpoint() end, "Set breakpoint" },
    B = { function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, "Set condition breakpoint" },
    f = { function() require("dapui").float_element() end, "Show Float Element" },
    k = { function() require("dapui").eval() end, "Show cursor eval" },
    l = { function() require("dap").list_breakpoints() end, "List Breakpoints" },
    t = { function() require("dap").repl.toggle() end, "Toggle REPL" },
    r = { function() require("dap").continue() end, "Debug run" },
  },
  g = {
    name = "Git",
    n = { function() require("gitsigns").next_hunk() end, "Next git hunk" },
    p = { function() require("gitsigns").prev_hunk() end, "Previous git hunk" },
    d = { function() require("gitsigns").diffthis() end, "Diff this" },
    c = { "<cmd>DiffviewFileHistory %<cr>", "Current file history" },
    h = { "<cmd>DiffviewFileHistory<cr>", "File History" },
    s = { function() require("gitsigns").preview_hunk() end, "Preview git hunk" },
    z = { function() require("gitsigns").reset_hunk() end, "Reset hunk" },
  },
  f = {
    name = "Find",
    d = { function() require("telescope.builtin").diagnostics() end, "Search diagnostics" },
    e = { function() require("memento").toggle() end, "Search history" },
    f = { function() require("telescope.builtin").find_files(require("telescope.themes").get_ivy { hidden = true }) end, "Search files" },
    m = { function() require("telescope.builtin").marks() end, "Search marks" },
    r = { function() require("telescope.builtin").registers() end, "Search registers" },
    s = { function() require("telescope.builtin").lsp_document_symbols() end, "Search symbols" },
    w = { function() require("telescope.builtin").live_grep(require("telescope.themes").get_ivy { hidden = true }) end, "Search Text" },
  },
  l = {
    name = "LSP",
    a = { function() vim.lsp.buf.code_action() end, "LSP code action" },
    f = { function() local bfn = vim.api.nvim_get_current_buf(); vim.lsp.buf.format { bufnr = bfn, filter = function(c) return require("user.core.lsp").filter_format_lsp_client(c, bfn) end, } end, "Format code" },
    i = { function() vim.lsp.buf.incoming_calls() end, "Incoming Calls" },
    o = { function() vim.lsp.buf.outgoing_calls() end, "Outgoing Calls" },
    r = { "<cmd>lua vim.lsp.codelens.refresh()<cr>", "Refresh Codelens" },
    e = { "<cmd>lua vim.lsp.codelens.run()<cr>", "Run Codelens" },
  },
  F = {
    name = "File",
    n = { "<cmd>enew<cr>", "New File" },
  },
  S = {
    name = "Session",
    d = { "<cmd>SessionManager! delete_session<cr>", "Delete session" },
    f = { "<cmd>SessionManager! load_session<cr>", "Search sessions" },
    l = { "<cmd>SessionManager! load_last_session<cr>", "Load last session" },
    s = { "<cmd>SessionManager! save_current_session<cr>", "Save this session" },
    ["."] = { "<cmd>SessionManager! load_current_dir_session<cr>", "Load current directory session" },
  },
  R = {
    name = "Replace",
    f = { function() require("spectre").open_file_search() end, "Replace File" },
    p = { function() require("spectre").open() end, "Replace Project" },
    s = { function() require("spectre").open_visual { select_word = true } end, "Search" },
  },
  H = {
    name = "Help",
    j = { function() require("telescope.builtin").jumplist() end, "Search jump list" },
    p = { "<cmd>Telescope projects<cr>", "List project" },
  },
  t = {
    name = "Terminal",
    t = { "<cmd>ToggleTerm direction=float<cr>", "ToggleTerm float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "ToggleTerm horizontal split" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "ToggleTerm vertical split" },
  },
  v = {
    name = "View",
    b = { function() require("telescope").extensions.file_browser.file_browser() end, "File browser" },
    o = { "<cmd>SymbolsOutline<cr>", "Symbols outline" },
    u = { "<cmd>UndotreeToggle<cr>", "UndoTree toggle" },
  },
}, { prefix = "<leader>", mode = "n", default_options })

wk.register({
  l = {
    name = "LSP",
    a = { function() vim.lsp.buf.range_code_action() end, "LSP code action" },
    f = { function() require("user.core.lsp").format_range_operator() end, "Format code" },
  },
  d = {
    k = { function() require("dapui").eval() end, "Show cursor eval" },
  },
}, { prefix = "<leader>", mode = "v", default_options })

