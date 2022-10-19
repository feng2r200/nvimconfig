local autocmd = vim.api.nvim_create_autocmd

vim.opt.title = true

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.ruler = false

vim.opt.cursorline = true

vim.opt.colorcolumn = "80,100"

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.encoding = "utf-8"
vim.opt.fileencodings = {"utf-8", "gb18030", "utf-16", "big5"}

vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false

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

autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.breakindentopt = "shift:2,min:20"
vim.opt.preserveindent = true

vim.opt.showmode = false

vim.opt.autoread = true

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 300

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.termguicolors = true

vim.opt.timeoutlen = 300

vim.opt.mouse = ""

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.backspace = vim.opt.backspace + { "nostop" }

vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.fillchars = { eob = " " }

vim.opt.history = 2000
vim.opt.jumpoptions = "stack"

vim.opt.diffopt = "filler,iwhite,internal,algorithm:patience"
vim.opt.grepprg = "rg --hidden --vimgrep --smart-case --"

vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.pumheight = 10
vim.opt.signcolumn = "yes"

vim.opt.wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**"

vim.g.python3_host_prog = '/usr/local/bin/python3'
vim.g.zipPlugin = false
vim.g.load_black = false
vim.g.loaded_2html_plugin = true
vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true
vim.g.loaded_gzip = true
vim.g.loaded_logipat = true
vim.g.loaded_matchit = true
vim.g.loaded_netrwFileHandlers = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettngs = true
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_remote_plugins = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true
vim.g.loaded_vimball = true
vim.g.loaded_vimballPlugin = true

autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

autocmd("FocusGained", {
  pattern = "*",
  command = "checktime",
})

autocmd("BufWritePre", {
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  command = "setlocal noundofile",
})

autocmd("VimResized", {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

