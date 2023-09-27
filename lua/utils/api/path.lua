local M = {}

---------------------------------------------------------------------------
local sep = (function()
  ---@diagnostic disable-next-line: undefined-global
  if jit then
    ---@diagnostic disable-next-line: undefined-global
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return string.sub(package.config, 1, 1)
  end
end)()

function M.join(...)
  return table.concat(vim.tbl_flatten { ... }, sep)
end

function M.exists(p)
  return vim.fn.filereadable(p) == 1
end

function M.listdir(p)
  return vim.fn.globpath(p, "*", false, true)
end

---------------------------------------------------------------------------

function M.generate_absolute_path(p)
  ---@diagnostic disable-next-line: undefined-field
  local full_path = debug.getinfo(2, "S").source:sub(2)
  local full_dirs = full_path:match "(.*[/\\])"

  local path1 = p:gsub("^%./", "")
  local path2, count = path1:gsub("%.%./", "")

  while count >= 0 do
    full_dirs = vim.fn.fnamemodify(full_dirs, ":h")
    count = count - 1
  end

  return full_dirs .. "/" .. path2
end

function M.generate_relative_path(p)
  local root_path = table.concat(vim.tbl_flatten { vim.fn.stdpath "config", "lua" }, "/")

  ---@diagnostic disable-next-line: undefined-field
  local full_path = debug.getinfo(2, "S").source:sub(2)
  local full_dirs = full_path:match "(.*[/\\])"

  local path1 = p:gsub("^%./", "")
  local path2, count = path1:gsub("%.%./", "")

  while count >= 0 do
    full_dirs = vim.fn.fnamemodify(full_dirs, ":h")
    count = count - 1
  end

  return full_dirs:sub(#root_path + 2) .. "/" .. path2
end

return M
