local autocmd = vim.api.nvim_create_autocmd
local Util = require "user.utils.utils"

-- Highlight on yank
autocmd({ "TextYankPost" }, {
  group = Util.augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
  end,
})

-- resize splits if window got resized
autocmd("VimResized", {
  group = Util.augroup "resize_splits",
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = Util.augroup "close_with_q",
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
  group = Util.augroup "wrap_spell",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix comment
autocmd({ "BufEnter", "BufWinEnter" }, {
  group = Util.augroup "comment_newline",
  pattern = { "*" },
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function()
    vim.cmd [[wincmd L]]
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
autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

-- disable list option in certain filetypes
autocmd("FileType", { pattern = { "NeoGitStatus" }, command = [[setlocal list!]] })

-- show cursor line only in active window
local cursorGrp = Util.augroup "cursor_line"
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

-- when there is no buffer left show Alpha dashboard
-- requires "famiu/bufdelete.nvim" and "goolord/alpha-nvim"
autocmd("User", {
  group = Util.augroup "alpha_on_empty",
  pattern = { "BDeletePost*" },
  callback = function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""

    if fallback_on_empty then
      -- require("neo-tree").close_all()
      vim.api.nvim_command "Alpha"
      vim.api.nvim_command(event.buf .. "bwipeout")
    end
  end,
})

autocmd("User", {
  pattern = { "AlphaReady" },
  callback = function()
    vim.cmd [[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]]
  end,
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

autocmd("FileType", {
  pattern = {
    "lua",
    "javascript",
    "json",
    "css",
    "html",
    "xml",
    "yaml",
    "http",
    "markdown",
    "lisp",
    "sh",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
