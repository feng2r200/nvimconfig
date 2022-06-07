local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = false, -- bindings for folds, spelling and others prefixed with z
      g = false, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<Space>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  e = {
    name = "View",
    e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    n = { "<cmd>ene<cr>", "New File"},
    o = { "<cmd>SymbolsOutline<CR>", "Outline" },
  },

  f = {
    name = "Finder",
    f = {
      "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_ivy())<cr>",
      "Find files",
    },
    F = { "<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>", "File browser" },
    g = {
      "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args(require('telescope.themes').get_ivy())<cr>",
      "Find Text"
    },
    s = {
      "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Find Document Symbols"
    },
    b = {
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Buffers"
    },
    m = { "<cmd>Telescope vim_bookmarks<cr>", "Marks" },
    c = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find{}<cr>", "Current buffer fuzzy find" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    p = { "<cmd>Telescope projects<cr>", "Projects" },
    P = { "<cmd>SessionManager load_session<cr>", "Projects" },
  },

  t = {
    t = {
      "<cmd>UltestSummary<CR>", "Unit Test"
    },
  },

  d = {
    name = "Debug",
    R = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    r = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
    B = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    l = { "<cmd>Telescope dap commands<cr>", "Toggle dap commands" },
  },

  T = {
    name = "Trouble",
    t = { "<cmd>Trouble<cr>", "ToggleTrouble" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "Document Diagnostics"},
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics"},
    q = { "<cmd>Trouble quickfix<cr>", "Quick Fix"},
    g = { "<cmd>Gitsigns setloclist<cr>", "Open changed hunk" },
  },

  g = {
     name = "Git",
     f = { "<cmd>DiffviewFileHistory<CR>", "File History" },
     p = { "<cmd>DiffviewOpen<CR>", "Diff Project" },
     n = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
     N = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
     l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
     r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
     R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
     s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
     S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage Hunk" },
     u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk", },
     U = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk", },
     o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
     b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
     c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
     d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff", },
   },

  R = {
    name = "Replace",
    f = { "<cmd>lua require('spectre').open_file_search()<CR>", "Replace File" },
    p = { "<cmd>lua require('spectre').open()<CR>", "Replace Project" },
    s = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search" },
    -- -- 全项目替换
    -- vim.keybinds.gmap("n", "<leader>rp", "", vim.keybinds.opts)
    -- -- 只替换当前文件
    -- vim.keybinds.gmap("n", "<leader>rf", , vim.keybinds.opts)
    -- -- 全项目中搜索当前单词
    -- vim.keybinds.gmap("n", "<leader>rw", , vim.keybinds.opts)
  },

  l = {
    name = "LSP",
    l = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = {
      "<cmd>Telescope lsp_document_diagnostics<cr>",
      "Document Diagnostics",
    },
    w = {
      "<cmd>Telescope lsp_workspace_diagnostics<cr>",
      "Workspace Diagnostics",
    },
    j = {
      "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Lspsaga signature_help<cr>", "Signature help", },
    i = { "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", "Income call" },
    o = { "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", "Out going call" },
    u = { "<cmd>lua require('telescope.builtin').lsp_references{}<cr>", "Usage"},
  },

  h = {
    name = "Help",
    -- b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    -- r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
  },

}

which_key.setup(setup)
which_key.register(mappings, opts)
