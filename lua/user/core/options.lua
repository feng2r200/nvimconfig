local options = {
  backup = false, -- creates a backup file
  swapfile = false, -- creates a swapfile
  history = 2000,
  jumpoptions = "stack",
  diffopt = "filler,iwhite,internal,algorithm:patience",
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  confirm = true, -- Confirm to save changes before exiting modified buffer
  completeopt = { "menu", "menuone", "noselect", "noinsert" }, -- mostly just for cmp
  wildignorecase = true,
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  incsearch = true,
  hlsearch = true, -- highlight all matches on previous search pattern
  inccommand = "nosplit",
  ignorecase = true, -- ignore case in search patterns
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --hidden --vimgrep --smart-case --",
  mouse = "nv", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  autoread = true,
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  copyindent = true,
  breakindentopt = "shift:2,min:20",
  preserveindent = true,
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
  ttimeoutlen = 0,
  undofile = true, -- enable persistent undo
  updatetime = 500, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 4, -- the number of spaces inserted for each indentation
  softtabstop = 4,
  tabstop = 4, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  ruler = false,
  colorcolumn = "80,100",
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  autoindent = true,
  scrolloff = 6,
  sidescrolloff = 8,
  laststatus = 3,
  lazyredraw = false,
  guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
  -- guicursor = "a:xxx",
  background = "dark",
  showcmd = false,
  mousemoveevent = true,
  syntax = "off",
  spelllang = { "en" },
  -- use fold
  foldlevelstart = 99,
  foldlevel = 99,
  foldenable = true,
  foldcolumn = "1",
  fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  },
  -- session
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
}

vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
vim.g.zipPlugin = false
vim.g.load_black = false
vim.g.loaded_2html_plugin = true
vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true
vim.g.loaded_gzip = true
vim.g.loaded_logipat = true
-- vim.g.loaded_matchit = true
vim.g.loaded_netrw = true
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

vim.g.cursorhold_updatetime = 100

vim.opt.shortmess:append "c"
vim.opt.viewoptions:remove "curdir" -- disable saving current directory with views

vim.opt.backspace:append { "nostop" }

vim.opt.list = true

vim.opt.wildignore = [[
.git,.hg,.svn
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class,*.pyc
*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
*.swp,.lock,.DS_Store,._*
*/tmp/*,**/tmp/**,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**",**/bower_modules/**
]]

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,]"
vim.cmd [[set iskeyword+=-]]
-- diable open fold with `l`
vim.cmd [[set foldopen-=hor]]

if vim.g.neovide then
  vim.opt.guifont = "Cascadia Code:h10" -- the font used in graphical neovim applications
  vim.g.neovide_scale_factor = 1
end

