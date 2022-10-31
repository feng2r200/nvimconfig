local binding = {}
local maps = setmetatable({}, {
  __index = function(_, key)
    if not binding[key] then
      binding[key] = {}
    end
    return binding[key]
  end
})

local mappings = {}
local function init_table(mode, prefix, idx, name)
  if not mappings[mode] then
    mappings[mode] = {}
  end
  if not mappings[mode][prefix] then
    mappings[mode][prefix] = {}
  end
  if not mappings[mode][prefix][idx] then
    mappings[mode][prefix][idx] = { name = name }
  end
end

------------------------------------------------------------------------

maps[""]["<Space>"] = "<Nop>"

maps.n["<BS>"]  = { ":nohlsearch<cr>", desc = "No Highlight" }
maps.n["<C-s>"] = { ":write<cr>", desc = "Force write" }
maps.i["<C-s>"] = { "<esc>:write<cr>i", desc = "Force write" }

-- Navigate buffers
maps.n["]b"] = { ":BufferLineCycleNext<cr>",  desc = "Next buffer tab" }
maps.n["[b"] = { ":BufferLineCyclePrev<cr>",  desc = "Previous buffer tab" }
maps.n[">b"] = { ":BufferLineMoveNext<cr>", desc = "Move buffer tab right" }
maps.n["<b"] = { ":BufferLineMovePrev<cr>", desc = "Move buffer tab left" }

-- Better window navigation
maps.n["<C-h>"] = { function() require("tmux").move_left() end, desc = "Move to left split" }
maps.n["<C-j>"] = { function() require("tmux").move_bottom() end, desc = "Move to below split" }
maps.n["<C-k>"] = { function() require("tmux").move_top() end, desc = "Move to above split" }
maps.n["<C-l>"] = { function() require("tmux").move_right() end, desc = "Move to right split" }

-- Resize with arrows
maps.n["<M-h>"] = { function() require("tmux").resize_left() end, desc = "Resize split left" }
maps.n["<M-j>"] = { function() require("tmux").resize_bottom() end, desc = "Resize split down" }
maps.n["<M-k>"] = { function() require("tmux").resize_top() end, desc = "Resize split up" }
maps.n["<M-l>"] = { function() require("tmux").resize_right() end, desc = "Resize split right" }

-- Stay in indent mode
maps.v["<C-j>"] = { ":m'>+1<cr>gv=gv", desc = "Move current line down"}
maps.v["<C-k>"] = { ":m'<-2<cr>gv=gv", desc = "Move current line up"}
maps.v["<"]     = { "<gv", desc = "unindent line" }
maps.v[">"]     = { ">gv", desc = "indent line" }

maps.n["<F12>"] = { ":MarkdownPreviewToggle<cr>", desc = "Markdown preview" }

------------------------------------------------------------------------

-- Buffers
maps.n["<Space>b"] = { function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown{previewer = false}) end, desc = "Search buffers" }
maps.v["<Space>gu"] = { function() require("utils").camel_case_start() end, desc = "Camel Case" }

-- motion
maps.n["<Space>j"] = { "<cmd>HopLine<cr>", desc = "Hop line" }
maps.n["<Space>k"] = { "<cmd>HopLine<cr>", desc = "Hop line" }
maps.n["<Space>w"] = { "<cmd>HopWord<cr>", desc = "Hop word" }
maps.n["<Space>s"] = { "<cmd>HopChar1<cr>", desc = "Hop char1" }

-- enhance f motion
maps.n["<Space>f"]   = { function() require("hop").hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true }) end, desc = "Enhance f" }
maps.n["<Space>F"]   = { function() require("hop").hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true }) end, desc = "Enhance F" }
maps.o["<Space>f"]   = { function() require("hop").hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true }) end, desc = "Enhance f" }
maps.o["<Space>F"]   = { function() require("hop").hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true }) end, desc = "Enhance F" }
maps[""]["<Space>t"] = { function() require("hop").hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true }) end, desc = "Enhance t" }
maps[""]["<Space>T"] = { function() require("hop").hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true }) end, desc = "Enhance T" }

-- GitSigns
init_table("n", "<Space>", "g", "Git")
maps.n["<Space>gd"] = { function() require("gitsigns").diffthis() end, desc = "Diff this" }
maps.n["<Space>gn"] = { function() require("gitsigns").next_hunk() end, desc = "Next git hunk" }
maps.n["<Space>gN"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous git hunk" }
maps.n["<Space>gp"] = { function() require("gitsigns").preview_hunk() end, desc = "Preview git hunk" }
maps.n["<Space>gP"] = { function() require("gitsigns").blame_line() end, desc = "Show Blame line" }

init_table("n", "<leader>", "g", "Git")
maps.n["<leader>gh"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" }
maps.n["<leader>gf"] = { "<cmd>DiffviewFileHistory<cr>", desc = "File History" }

-- Session Manager
init_table("n", "<leader>", "S", "Session")
maps.n["<leader>Sd"] = { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
maps.n["<leader>Sf"] = { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
maps.n["<leader>Sl"] = { "<cmd>SessionManager! load_last_session<cr>", desc = "Load last session" }
maps.n["<leader>Ss"] = { "<cmd>SessionManager! save_current_session<cr>", desc = "Save this session" }
maps.n["<leader>S."] = { "<cmd>SessionManager! load_current_dir_session<cr>", desc = "Load current directory session" }

-- file
init_table("n", "<leader>", "f", "File")
maps.n["<leader>fe"] = { function() require("memento").toggle() end, desc = "Search history" }
maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files(require("telescope.themes").get_ivy()) end, desc = "Search files" }
maps.n["<leader>fn"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["<leader>fw"] = { function() require("telescope.builtin").live_grep(require("telescope.themes").get_ivy()) end, desc = "Search Text" }

-- Search
init_table("n", "<leader>", "s", "Search")
maps.n["<leader>sd"] = { function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" }
maps.n["<leader>sm"] = { function() require("telescope.builtin").marks() end, desc = "Search marks" }
maps.n["<leader>sr"] = { function() require("telescope.builtin").registers() end, desc = "Search registers" }
maps.n["<leader>ss"] = { function() require("telescope.builtin").lsp_document_symbols() end, desc = "Search symbols" }
maps.n["<leader>sw"] = { function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzy finder current buf"}

-- Help
init_table("n", "<leader>", "H", "Help")
maps.n["<leader>Hh"] = { function() require("telescope.builtin").help_tags() end, desc = "Search help" }
maps.n["<leader>Hj"] = { function() require("telescope.builtin").jumplist() end, desc = "Search jump list" }
maps.n["<leader>Hm"] = { function() require("telescope.builtin").man_pages() end, desc = "Search man" }
maps.n["<leader>Hp"] = { "<cmd>Telescope projects<cr>", desc = "List project" }

-- Replace
init_table("n", "<leader>", "R", "Replace")
maps.n["<leader>Rf"] = { function() require("spectre").open_file_search() end, desc = "Replace File" }
maps.n["<leader>Rp"] = { function() require("spectre").open() end, desc = "Replace Project" }
maps.n["<leader>Rs"] = { function() require("spectre").open_visual({select_word=true}) end, desc = "Search" }

-- Terminal
maps.n["<C-t>"]      = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }

init_table("n", "<leader>", "t", "Terminal")
maps.n["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
maps.n["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
maps.n["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }

-- LSP
maps.n["K"]  = { function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
  elseif vim.fn.expand "%:t" == "Cargo.toml" then
    local crates_status, crates = pcall(require, "crates")
    if crates_status then
      crates.show_popup()
    else
      vim.lsp.buf.hover()
    end
  else
    vim.lsp.buf.hover()
  end
end, desc = "Hover symbol details" }
maps.n["gd"] = { function() require("telescope.builtin").lsp_definitions{} end, desc = "Show the definition of current symbol" }
maps.n["gD"] = { function() require("telescope.builtin").lsp_type_definitions{} end, desc = "Declaration of current symbol" }
maps.n["gh"] = { function() require("telescope.builtin").lsp_references{} end, desc = "Search references" }
maps.n["gi"] = { function() require("telescope.builtin").lsp_implementations{} end, desc = "Implementation of current symbol" }
maps.n["gr"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" }
maps.n["gs"] = { function() vim.lsp.buf.signature_help() end, desc = "Signature help" }

maps.n["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" }
maps.n["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" }
maps.n["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }

init_table("n", "<leader>", "l", "LSP")
maps.n["<leader>la"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" }
maps.v["<leader>la"] = { function() vim.lsp.buf.range_code_action() end, desc = "LSP code action" }
maps.n["<leader>lf"] = { function()
  local bfn = vim.api.nvim_get_current_buf()
  vim.lsp.buf.format({
    bufnr = bfn,
    filter = function(c)
      return require("lsp.utils").filter_format_lsp_client(c, bfn)
    end
  })
end, desc = "Format code" }
maps.v["<leader>lf"] = { function() require("lsp.utils").format_range_operator() end, desc = "Format code" }
maps.n["<leader>li"] = { function() vim.lsp.buf.incoming_calls() end, desc = "Incoming Calls" }
maps.n["<leader>lo"] = { function() vim.lsp.buf.outgoing_calls() end, desc = "Outgoing Calls" }
maps.n["<leader>lr"] = { "<cmd>lua vim.lsp.codelens.refresh()<cr>", desc = "Refresh Codelens" }
maps.n["<leader>le"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "Run Codelens" }

-- Debug
maps.n["<F4>"] = { function() require("dap").terminate() end, desc = "Debug terminate" }
maps.n["<F5>"] = { function() require("dap").continue() end, desc = "Debug continue" }
maps.n["<F6>"] = { function() require("dap").step_over() end, desc = "Debug step over" }
maps.n["<F7>"] = { function() require("dap").step_into() end, desc = "Debug step into" }
maps.n["<F8>"] = { function() require("dap").step_out() end, desc = "Debug step out" }

init_table("n", "<leader>", "d", "Debug")
maps.n["<leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Set breakpoint" }
maps.n["<leader>dB"] = { function() require("dap").set_breakpoint(vim.fn.input '[Condition] > ') end, desc = "Set condition breakpoint" }
maps.n["<leader>df"] = { function() require("dapui").float_element() end, desc = "Show Float Element" }
maps.n["<leader>dk"] = { function() require("dapui").eval() end, desc = "Show cursor eval" }
maps.v["<leader>dk"] = { function() require("dapui").eval() end, desc = "Show cursor eval" }
maps.n["<leader>dl"] = { function() require("dap").list_breakpoints() end, desc = "List Breakpoints" }
maps.n["<leader>dt"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" }
maps.n["<leader>dr"] = { function() require("dap").continue() end, desc = "Debug run" }

-- View
init_table("n", "<leader>", "v", "View")
maps.n["<leader>vb"] = { function() require("telescope").extensions.file_browser.file_browser() end, desc = "File browser" }
maps.n["<leader>vd"] = { "<cmd>Trouble document_diagnostics<cr>", desc = "Trouble Document Diagnostics"}
maps.n["<leader>ve"] = { "<cmd>NvimTreeToggle<cr>", desc = "Tree Explorer" }
maps.n["<leader>vg"] = { "<cmd>DiffviewOpen<cr>", desc = "Sidebar Diff Project" }
maps.n["<leader>vh"] = { "<cmd>Trouble lsp_references<cr>", desc = "Trouble LSP Usage"}
maps.n["<leader>vo"] = { "<cmd>SymbolsOutline<cr>", desc = "Symbols outline" }
maps.n["<leader>vq"] = { "<cmd>Trouble quickfix<cr>", desc = "Trouble Quick Fix"}
maps.n["<leader>vt"] = { "<cmd>Trouble<cr>", desc = "Toggle trouble" }
maps.n["<leader>vu"] = { "<cmd>UndotreeToggle<cr>", desc = "UndoTree toggle" }
maps.n["<leader>vw"] = { "<cmd>Trouble workspace_diagnostics<cr>", desc = "Trouble Workspace Diagnostics"}

------------------------------------------------------------------------

local function set_mappings(map_table, base)
  for mode, mapping in pairs(map_table) do
    for keymap, options in pairs(mapping) do
      if options then
        local cmd = options
        if type(options) == "table" then
          cmd = options[1]
          options[1] = nil
        else
          options = {}
        end
        vim.keymap.set(mode, keymap, cmd, vim.tbl_deep_extend("force", options, base or {}))
      end
    end
  end
end

set_mappings(binding, { noremap = true, silent = true })

------------------------------------------------------------------------

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  return
end

for mode, prefixes in pairs(mappings) do
  for prefix, mapping_table in pairs(prefixes) do
    wk.register(mapping_table, {
      mode = mode,
      prefix = prefix,
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
    })
  end
end

