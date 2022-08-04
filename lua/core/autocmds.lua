local cmd = vim.api.nvim_create_autocmd

cmd("User", {
  pattern = { "AlphaReady" },
  callback = function()
    vim.cmd [[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]]
  end,
})

cmd("ColorScheme", {
  callback = function()
    package.loaded["configs.feline"] = nil
    require "configs.feline"
  end,
})

cmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
  end,
})

cmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

cmd("FocusGained", {
  pattern = "*",
  command = "checktime",
})

cmd("VimResized", {
  pattern = "*",
  command = [[tabdo wincmd =]],
})

cmd("BufWritePre", {
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  command = "setlocal noundofile",
})

cmd("BufWritePost", {
  pattern = "plugins.lua",
  command = "source <afile> | PackerSync",
})

cmd("FileType", {
  pattern = { "c", "cpp", "python", "java" },
  command = "set shiftwidth=4 tabstop=4",
})
cmd("FileType", {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "DressingSelect" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]]
  end,
})
cmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
cmd("FileType", {
  pattern = { "lir" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

cmd("VimResized", {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

cmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
  pattern = { "*.java", "*.py", "*.rs" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

cmd({ "CursorHold", "ModeChanged" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})
