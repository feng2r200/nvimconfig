local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

augroup("neotree_start", { clear = true })
cmd("BufEnter", {
  desc = "Open Neo-Tree on startup with directory",
  group = "neotree_start",
  callback = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == "directory" then
      require("neo-tree.setup.netrw").hijack()
    end
  end,
})

augroup("feline_setup", { clear = true })
cmd("ColorScheme", {
  desc = "Reload feline on colorscheme change",
  group = "feline_setup",
  callback = function()
    package.loaded["configs.feline"] = nil
    require "configs.feline"
  end,
})

augroup("yank", { clear = true })
cmd("TextYankPost", {
  desc = "Highlight on yank",
  group = "yank",
  pattern = "*",
  command = [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]],
})

augroup("formatopts", { clear = true })
cmd("FileType", {
  desc = "Format options configuration.",
  group = "formatopts",
  pattern = "*",
  command = [[setlocal formatoptions-=c formatoptions-=r formatoptions-=o]],
})

augroup("wins", { clear = true })
cmd("FocusGained", {
  desc = "Check if file changed when its window is focus, more eager than 'autoread'",
  group = "wins",
  pattern = "*",
  command = "checktime",
})
cmd("VimResized", {
  desc = "Equalize window dimensions when resizing vim window",
  group = "wins",
  pattern = "*",
  command = [[tabdo wincmd =]],
})

augroup("bufs", { clear = true })
cmd("BufWritePre", {
  desc = "Set no undo file buffers",
  group = "bufs",
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  command = "setlocal noundofile",
})

augroup("filetype", { clear = true })
cmd("FileType", {
  desc = "Set python,java tab",
  group = "filetype",
  pattern = { "python", "java" },
  command = "set shiftwidth=4 tabstop=4",
})
