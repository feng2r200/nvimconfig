local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = "python",
  args = {"-m", "debugpy.adapter"}
}
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}",
    stopOnEntry = false
  }
}
