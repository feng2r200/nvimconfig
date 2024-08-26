local M = {}

M.root_patterns = { ".git", "lua", "package.json", "mvnw", "gradlew", "pom.xml", "build.gradle", "release", ".project", ".env", "venv" }

M.get_root = function()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

M.set_root = function(dir)
  vim.api.nvim_set_current_dir(dir)
end

M.get_python_path = function(workspace)
  local path = require("lspconfig/util").path
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs { "*", ".*" } do
    local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if match ~= "" then
      return path.join(path.dirname(match), "bin", "python")
    end
  end
  -- Fallback to system Python.
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

return M
