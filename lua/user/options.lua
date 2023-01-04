vim.opt.title = true

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.ruler = false

vim.opt.cursorline = true

vim.opt.colorcolumn = "80,100"
vim.opt.list = true

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shortmess = vim.opt.shortmess + "c"

vim.g.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "gb18030", "utf-16", "big5" }

vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false

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
vim.opt.ttimeoutlen = 0

vim.opt.mouse = "nv"

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.backspace = vim.opt.backspace + { "nostop" }

vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.wildignorecase = true

vim.opt.fillchars = { eob = " " }

vim.opt.history = 2000
vim.opt.jumpoptions = "stack"

vim.opt.diffopt = "filler,iwhite,internal,algorithm:patience"
vim.opt.grepprg = "rg --hidden --vimgrep --smart-case --"

vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.pumheight = 10
vim.opt.signcolumn = "yes"

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

vim.g.python3_host_prog = "/usr/local/bin/python3"
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
