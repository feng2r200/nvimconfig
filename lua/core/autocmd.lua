local augroup = function(name)
  return vim.api.nvim_create_augroup("usr_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd({ "TextYankPost" }, {
  group = augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
  end,
})

-- resize splits if window got resized
autocmd("VimResized", {
  group = augroup "resize_splits",
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
    "lir",
    "DressingSelect",
    "fugitive",
    "null-ls-info",
    "dap-float",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Set wrap and spell in markdown and gitcommit
autocmd("FileType", {
  group = augroup "wrap_spell",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix comment
autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup "comment_newline",
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})

autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local["number"] = false
    vim.opt_local["signcolumn"] = "no"
    vim.opt_local["foldcolumn"] = "0"
  end,
})

autocmd("FocusGained", {
  pattern = "*",
  command = "checktime",
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  pattern = { "*" },
  callback = function()
    if vim.fn.line "'\"" > 0 and vim.fn.line "'\"" <= vim.fn.line "$" then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.fn.setpos(".", vim.fn.getpos "'\"")
      -- vim.cmd('normal zz')
      vim.cmd "silent! foldopen"
    end
  end,
})

-- disable list option in certain filetypes
autocmd("FileType", { pattern = { "NeoGitStatus" }, command = [[setlocal list!]] })

-- show cursor line only in active window
local cursorGrp = augroup "cursor_line"
autocmd({ "InsertLeave", "WinEnter" }, {
  group = cursorGrp,
  pattern = "*",
  command = "set cursorline",
})
autocmd({ "InsertEnter", "WinLeave" }, {
  group = cursorGrp,
  pattern = "*",
  command = "set nocursorline",
})

-- Enable spell checking for certain file types
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = "en"
  end,
})

autocmd("BufWritePre", {
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  command = "setlocal noundofile",
})

