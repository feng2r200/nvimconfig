local cmd = vim.api.nvim_create_autocmd

cmd("BufEnter", {
  callback = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == "directory" then
      require("neo-tree.setup.netrw").hijack()
    end
  end,
})

cmd("ColorScheme", {
  callback = function()
    package.loaded["configs.feline"] = nil
    require "configs.feline"
  end,
})

cmd("TextYankPost", {
  pattern = "*",
  command = [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]],
})

cmd("FileType", {
  pattern = "*",
  command = [[setlocal formatoptions-=c formatoptions-=r formatoptions-=o]],
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

cmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

cmd({ "CursorHold", "ModeChanged" }, {
  callback = function()
    local luasnip = require "luasnip"
    if luasnip.expand_or_jumpable() then
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})
