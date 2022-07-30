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
		  local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.env/bin/python") == 1 then
				return cwd .. "/.env/bin/python"
			else
        return "python"			end
		end,
	},
}

