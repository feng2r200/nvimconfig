local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

local M = {}

local function config_dapi_and_sign()
  local dap_breakpoint = {
    error = {
      text = "🛑",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "⭐️",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

  dap.defaults.fallback.terminal_win_cmd = '30vsplit new' -- this will be overrided by dapui
  dap.set_log_level("DEBUG")
end

local function config_debuggers()
  for _, dap_opt in ipairs {
    "dap.python",
    "dap.go",
    "dap.cpp",
  } do
    local opt_status_ok, fault = pcall(require, dap_opt)
    if not opt_status_ok then
      vim.api.nvim_err_writeln("Failed to load " .. dap_opt .. "\n\n" .. fault)
    end
  end
end

function M.setup()
  config_dapi_and_sign()
  config_debuggers()
end

M.setup()
