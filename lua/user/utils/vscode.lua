local M = {}

M.get_vscode_extensions = function()
  return os.getenv "HOME" .. "/.vscode/extensions"
end
M.find_one = function(extension_path)
  local v = vim.fn.glob(M.get_vscode_extensions() .. extension_path)
  if v and v ~= "" then
    if type(v) == "string" then
      return vim.split(v, "\n")[1]
    elseif type(v) == "table" then
      return v[1]
    end
    return v
  end
end

return M
