_G.mivim = {}
local stdpath = vim.fn.stdpath
local tbl_insert = table.insert
local map = vim.keymap.set

mivim.compile_path = stdpath "data" .. "/packer_compiled.lua"

local function load_module_file(module)
  local found_module = nil

  local module_path = stdpath "config" .. "/lua/" .. module:gsub("%.", "/") .. ".lua"
  if vim.fn.filereadable(module_path) == 1 then
    found_module = module_path
  end

  if found_module then
    local status_ok, loaded_module = pcall(require, module)
    if status_ok then
      found_module = loaded_module
    else
      print("Error loading " .. found_module, "error")
    end
  end
  return found_module
end

local function func_or_extend(overrides, default, extend)
  if extend then
    if type(overrides) == "table" then
      default = vim.tbl_deep_extend("force", default, overrides)
    elseif type(overrides) == "function" then
      default = overrides(default)
    end
  elseif overrides ~= nil then
    default = overrides
  end
  return default
end

function mivim.conditional_func(func, condition, ...)
  if (condition == nil and true or condition) and type(func) == "function" then
    return func(...)
  end
end

function mivim.trim_or_nil(str)
  return type(str) == "string" and vim.trim(str) or nil
end

function mivim.echo(messages)
  messages = messages or {{"\n"}}
  if type(messages) == "table" then
    vim.api.nvim_echo(messages, false, {})
  end
end

function mivim.confirm_prompt(messages)
  if messages then
    mivim.echo(messages)
  end
  local confirmed = string.lower(vim.fn.input "(y/n) ") == "y"
  mivim.echo()
  mivim.echo()
  return confirmed
end

function mivim.initialize_packer()
  local packer_avail, packer = pcall(require, "packer")
  if not packer_avail then
    local packer_path = stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    vim.fn.delete(packer_path, "rf")
    vim.fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    }
    mivim.echo { { "Initializing Packer...\n\n" } }
    vim.cmd "packadd packer.nvim"
    packer_avail, packer = pcall(require, "packer")
    if not packer_avail then
      vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path .. "\n\n" .. packer)
    end
  end
  return packer
end

function mivim.vim_opts(options)
  for scope, table in pairs(options) do
    for setting, value in pairs(table) do
      vim[scope][setting] = value
    end
  end
end

function mivim.compiled()
  local run_me, _ = loadfile(mivim.compile_path)
  if run_me then
    run_me()
  else
    mivim.echo { { "Please run " }, { ":PackerSync", "Title" } }
  end
end

-- term_details can be either a string for just a command or
-- a complete table to provide full access to configuration when calling Terminal:new()
mivim.user_terminals = {}
function mivim.toggle_term_cmd(term_details)
  if type(term_details) == "string" then
    term_details = { cmd = term_details, hidden = true }
  end
  local term_key = term_details.cmd
  if vim.v.count > 0 and term_details.count == nil then
    term_details.count = vim.v.count
    term_key = term_key .. vim.v.count
  end
  if mivim.user_terminals[term_key] == nil then
    mivim.user_terminals[term_key] = require("toggleterm.terminal").Terminal:new(term_details)
  end
  mivim.user_terminals[term_key]:toggle()
end

function mivim.add_cmp_source(source)
  local cmp_avail, cmp = pcall(require, "cmp")
  if cmp_avail then
    local config = cmp.get_config()
    tbl_insert(config.sources, source)
    cmp.setup(config)
  end
end

function mivim.get_user_cmp_source(source)
  source = type(source) == "string" and { name = source } or source
  local cmp_source_priority = {
    nvim_lsp = 1000,
    luasnip = 750,
    buffer = 500,
    path = 250,
  }
  local priority = cmp_source_priority[source.name]
  if priority then
    source.priority = priority
  end
  return source
end

function mivim.add_user_cmp_source(source)
  mivim.add_cmp_source(mivim.get_user_cmp_source(source))
end

function mivim.null_ls_providers(filetype)
  local registered = {}
  local sources_avail, sources = pcall(require, "null-ls.sources")
  if sources_avail then
    for _, source in ipairs(sources.get_available(filetype)) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        tbl_insert(registered[method], source.name)
      end
    end
  end
  return registered
end

function mivim.null_ls_sources(filetype, source)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and mivim.null_ls_providers(filetype)[methods.internal[source]] or {}
end

function mivim.is_available(plugin)
  return packer_plugins ~= nil and packer_plugins[plugin] ~= nil
end

function mivim.set_mappings(map_table, base)
  for mode, maps in pairs(map_table) do
    for keymap, options in pairs(maps) do
      if options then
        local cmd = options
        if type(options) == "table" then
          cmd = options[1]
          options[1] = nil
        else
          options = {}
        end
        map(mode, keymap, cmd, vim.tbl_deep_extend("force", options, base or {}))
      end
    end
  end
end

function mivim.delete_url_match()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then
      vim.fn.matchdelete(match.id)
    end
  end
end

function mivim.set_url_match()
  mivim.delete_url_match()
  if vim.g.highlighturl_enabled then
    vim.fn.matchadd("HighlightURL", mivim.url_matcher, 15)
  end
end

function mivim.toggle_url_match()
  vim.g.highlighturl_enabled = not vim.g.highlighturl_enabled
  mivim.set_url_match()
end

function mivim.cmd(cmd, show_error)
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar "shell_error" == 0
  if not success and (show_error == nil and true or show_error) then
    vim.api.nvim_err_writeln("Error running command: " .. cmd .. "\nError message:\n" .. result)
  end
  return success and result or nil
end

return mivim
