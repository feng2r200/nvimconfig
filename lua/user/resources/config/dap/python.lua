local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

local root_path = require("user.util").get_root()
local python_path = require("user.util").get_python_path(root_path)

dap.adapters.python = {
  type = "executable",
  command = python_path,
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
    pythonPath = python_path,
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
    pythonPath = python_path,
    console = "internalConsole",
  },
}
