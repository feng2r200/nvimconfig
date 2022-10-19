local M = { hl = {}, provider = {}, conditional = {} }
local C = require "themes.colors"

local function hl_by_name(name)
  return string.format("#%06x", vim.api.nvim_get_hl_by_name(name.group, true)[name.prop])
end

local function hl_prop(group, prop)
  local status_ok, color = pcall(hl_by_name, { group = group, prop = prop })
  return status_ok and color or nil
end

local function null_ls_providers(filetype)
  local registered = {}
  local sources_avail, sources = pcall(require, "null-ls.sources")
  if sources_avail then
    for _, source in ipairs(sources.get_available(filetype)) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.name)
      end
    end
  end
  return registered
end

local function null_ls_sources(filetype, source)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and null_ls_providers(filetype)[methods.internal[source]] or {}
end

M.modes = {
  ["n"] = { "NORMAL", "Normal", C.blue },
  ["no"] = { "N-PENDING", "Normal", C.blue },
  ["i"] = { "INSERT", "Insert", C.green },
  ["ic"] = { "INSERT", "Insert", C.green },
  ["t"] = { "TERMINAL", "Insert", C.green },
  ["v"] = { "VISUAL", "Visual", C.purple },
  ["V"] = { "V-LINE", "Visual", C.purple },
  [""] = { "V-BLOCK", "Visual", C.purple },
  ["R"] = { "REPLACE", "Replace", C.red },
  ["Rv"] = { "V-REPLACE", "Replace", C.red },
  ["s"] = { "SELECT", "Visual", C.orange },
  ["S"] = { "S-LINE", "Visual", C.orange },
  [""] = { "S-BLOCK", "Visual", C.orange },
  ["c"] = { "COMMAND", "Command", C.yellow },
  ["cv"] = { "COMMAND", "Command", C.yellow },
  ["ce"] = { "COMMAND", "Command", C.yellow },
  ["r"] = { "PROMPT", "Inactive", C.grey },
  ["rm"] = { "MORE", "Inactive", C.grey },
  ["r?"] = { "CONFIRM", "Inactive", C.grey },
  ["!"] = { "SHELL", "Inactive", C.grey },
}

function M.hl.group(hlgroup, base)
  return vim.tbl_deep_extend(
    "force",
    base or {},
    { fg = hl_prop(hlgroup, "foreground"), bg = hl_prop(hlgroup, "background") }
  )
end

function M.hl.fg(hlgroup, base)
  return vim.tbl_deep_extend("force", base or {}, { fg = hl_prop(hlgroup, "foreground") })
end

function M.hl.mode(base)
  local lualine = require("themes.lualine")
  return function()
    local lualine_opts = lualine[M.modes[vim.fn.mode()][2]:lower()]
    return M.hl.group(
      "Feline" .. M.modes[vim.fn.mode()][2],
      vim.tbl_deep_extend(
        "force",
        lualine_opts and type(lualine_opts.a) == "table" and lualine_opts.a
          or { fg = C.bg_1, bg = M.modes[vim.fn.mode()][3] },
        base or {}
      )
    )
  end
end

function M.provider.lsp_progress()
  local Lsp = vim.lsp.util.get_progress_messages()[1]
  return Lsp
      and string.format(
        " %%<%s %s %s (%s%%%%) ",
        ((Lsp.percentage or 0) >= 70 and { "", "", "" } or { "", "", "" })[math.floor(
          vim.loop.hrtime() / 12e7
        ) % 3 + 1],
        Lsp.title or "",
        Lsp.message or "",
        Lsp.percentage or 0
      )
    or ""
end

function M.provider.lsp_client_names(expand_null_ls)
  return function()
    local buf_client_names = {}
    for _, client in pairs(vim.lsp.buf_get_clients(0)) do
      if client.name == "null-ls" and expand_null_ls then
        vim.list_extend(buf_client_names, null_ls_sources(vim.bo.filetype, "FORMATTING"))
        vim.list_extend(buf_client_names, null_ls_sources(vim.bo.filetype, "DIAGNOSTICS"))
      else
        table.insert(buf_client_names, client.name)
      end
    end
    return table.concat(buf_client_names, ", ")
  end
end

function M.provider.gps()
  return function ()
    local gps_status_ok, gps = pcall(require, "nvim-navic")
    return gps_status_ok and gps.get_location() or ""
  end
end

function M.provider.spacer(n)
  return string.rep(" ", n or 1)
end

function M.conditional.git_available()
  return vim.b.gitsigns_head ~= nil
end

function M.conditional.git_changed()
  local git_status = vim.b.gitsigns_status_dict
  return git_status and (git_status.added or 0) + (git_status.removed or 0) + (git_status.changed or 0) > 0
end

function M.conditional.has_filetype()
  return vim.fn.empty(vim.fn.expand "%:t") ~= 1 and vim.bo.filetype and vim.bo.filetype ~= ""
end

function M.conditional.bar_width(n)
  return function()
    return (vim.opt.laststatus:get() == 3 and vim.opt.columns:get() or vim.fn.winwidth(0)) > (n or 80)
  end
end

function M.conditional.gps_available()
  return function()
    local gps_status_ok, gps = pcall(require, "nvim-navic")
    return gps_status_ok and gps.is_available() or false
  end
end

local function isempty(s)
  return s == nil or s == ""
end

function M.provider.get_filename()
  return function()
    local filename = vim.fn.expand "%:."
    local extension = vim.fn.expand "%:e"

    local file_icon, file_icon_color =
    require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if isempty(file_icon) then
      file_icon = ""
      file_icon_color = ""
    end

    vim.api.nvim_set_hl(0, "Winbar", { fg = C.fg })

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
  end
end

function M.conditional.has_filename()
  return function()
    local filename = vim.fn.expand "%:t"
    return not isempty(filename) or false
  end
end

function M.provider.modified_icon()
  return function()
    return "[*]" or ""
  end
end

function M.conditional.is_modified()
  return function()
    return vim.o.modified or false
  end
end

return M
