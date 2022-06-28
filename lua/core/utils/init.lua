_G.mivim = {}
local tbl_insert = table.insert
local map = vim.keymap.set

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

function mivim.vim_opts(options)
  for scope, table in pairs(options) do
    for setting, value in pairs(table) do
      vim[scope][setting] = value
    end
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

return mivim

