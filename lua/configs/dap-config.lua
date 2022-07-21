local status_dap_ok, dap = pcall(require, "dap")
if not status_dap_ok then
  return
end

local dap_virtual_status_ok, dap_virtual = pcall(require, "nvim-dap-virtual-text")
if dap_virtual_status_ok then
  dap_virtual.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
  }
end

local status_dapui_ok, dapui = pcall(require, "dapui")
if status_dapui_ok then
   dapui.setup ({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "o", "<2-LeftMouse>", "<CR>" },
      open = "O",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    expand_lines = vim.fn.has("nvim-0.7"),
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.35 },
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "console",
        },
        size = 0.25,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
    },
  })

  local function debug_open()
    dapui.open()
    vim.api.nvim_command("DapVirtualTextEnable")
  end

  local function debug_close()
    vim.api.nvim_command("DapVirtualTextDisable")
    -- dap.repl.close()
    dapui.close()
  end

  dap.listeners.after.event_initialized["dapui"] = function()
    debug_open()
  end
  dap.listeners.before.event_terminated["dapui"] = function()
    debug_close()
  end
  dap.listeners.before.event_exited["dapui"]     = function()
    debug_close()
  end
  dap.listeners.before.disconnect["dapui"]       = function()
    debug_close()
  end
end

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

-- dap.set_log_level("DEBUG")

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

