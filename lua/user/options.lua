local function load_options()
  local option_local = {
    termguicolors = true,
    list = true,
    mouse = "a",
    encoding = "utf-8",
    fileencoding = "utf-8",
    clipboard = "unnamedplus",
    wildignorecase = true,
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,*.DS_Store,**/node_modules/**,**/bower_modules/**",
    backup = false,
    writebackup = false,
    swapfile = false,
    history = 2000,
    shada = "!,'300,<100,@50,s1000,:0,h",
    backupskip = "$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
    timeout = true,
    ttimeout = true,
    timeoutlen = 500,
    ttimeoutlen = 0,
    updatetime = 100,
    redrawtime = 1500,
    ignorecase = true,
    smartcase = true,
    smartindent = true,
    grepprg = "rg --hidden --vimgrep --smart-case --",
    whichwrap = "b,s,<,>,[,],h,l,~",
    splitbelow = true,
    splitright = true,
    backspace = "indent,eol,start",
    diffopt = "vertical,filler,iwhite,iblank,internal,algorithm:patience,context:4",
    completeopt = { "menu", "menuone", "noselect" },
    jumpoptions = "stack",
    showmode = false,
    shortmess = "aoOTIcF",
    scrolloff = 8,
    sidescrolloff = 8,
    showtabline = 2,
    pumheight = 15,
    showcmd = false,
    cmdheight = 1,
    equalalways = false,
    display = "lastline",
    pumblend = 10,
    winblend = 10,
    foldlevelstart = 99,
    cursorline = true,
    colorcolumn = "81,101",
  }
  for name, value in pairs(option_local) do vim.opt[name] = value end

  local bw_local = {
    undofile = true,
    autoread = true,
    autowrite = true,
    expandtab = true,
    autoindent = true,
    tabstop = 2,
    shiftwidth = 2,
    wrap = false,
    number = true,
    relativenumber = true,
    foldenable = true,
    signcolumn = "yes",
    conceallevel = 0,
    concealcursor = "niv",
    cscopequickfix = "s-,c-,d-,i-,t-,e-,a-",
  }
  for k, v in pairs(bw_local) do
    if v == true then
      vim.cmd("set " .. k)
    elseif v == false then
      vim.cmd("set no" .. k)
    else
      vim.cmd("set " .. k .. "=" .. v)
    end
  end

  local global_local = {
    clipboard = {
      name = "macOS-clipboard",
      copy = {["+"] = "pbcopy", ["*"] = "pbcopy"},
      paste = {["+"] = "pbpaste", ["*"] = "pbpaste"},
      cache_enabled = 0
    },
    python_host_prog = "/usr/bin/python",
    python3_host_prog = "/usr/local/bin/python3",
    loaded_python_provider = 0,
    loaded_perl_provider = 0,
    loaded_ruby_provider = 0,
  }
  for name, value in pairs(global_local) do vim.g[name] = value end
end

load_options()

