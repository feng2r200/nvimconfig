local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

local function get_python()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/.env/bin/python") == 1 then
    return cwd .. "/.env/bin/python"
  else
    return "/usr/local/bin/python3"
  end
end

dap.adapters.python = {
  type = "executable",
  command = get_python(),
  args = { "-m", "debugpy.adapter" },
  options = {
    source_filetype = "python",
  },
}

dap.configurations.python = {
  {
    type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = "launch",
    name = "Launch file",
    program = "${file}", -- This configuration will launch the current file if used.
    pythonPath = get_python(),
    console = "internalConsole",
  },
  {
    type = "python",
    request = "launch",
    name = "Launch file with arguments",
    program = "${file}",
    args = function()
      local args_string = vim.fn.input "Arguments: "
      return vim.split(args_string, " +")
    end,
    pythonPath = get_python(),
    console = "internalConsole",
  },
}
