local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

dap.adapters.python = {
  type = "executable",
	command = "python",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",
		program = "${file}", -- This configuration will launch the current file if used.
		pythonPath = function()
      return "python"
		end,
	},
}

