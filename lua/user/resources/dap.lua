local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
}

M.config = function()
  local dap_virtual = require "nvim-dap-virtual-text"
  dap_virtual.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    show_stop_reason = true,
    commented = true,
    only_first_definition = true,
    all_references = false,
    virt_text_pos = "eol",
    all_frames = true,
    virt_lines = false,
    virt_text_win_col = nil,
  }

  local dapui = require "dapui"
  dapui.setup {
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "o", "<CR>" },
      open = "O",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    expand_lines = vim.fn.has "nvim-0.7" == 1,
    layouts = {
      {
        elements = {
          "scopes",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
        },
        size = 0.25,
        position = "bottom",
      },
    },
    controls = {
      enabled = false,
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "↻",
        terminate = "□",
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
      max_value_lines = 100,
    },
  }

  local function debug_open()
    dapui.open()
    vim.api.nvim_command "DapVirtualTextEnable"
  end

  local dap = require "dap"
  local function debug_close()
    vim.api.nvim_command "DapVirtualTextDisable"
    -- dap.repl.close()
    dapui.close()
  end

  dap.listeners.after.event_initialized["dapui"] = function()
    debug_open()
  end
  dap.listeners.before.event_terminated["dapui"] = function()
    debug_close()
  end
  dap.listeners.before.event_exited["dapui"] = function()
    debug_close()
  end
  dap.listeners.before.disconnect["dapui"] = function()
    debug_close()
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

  dap.defaults.fallback.external_terminal = {
    command = "/usr/local/bin/alacritty",
    args = { "--hold", "--title", "DapExternal", "-e" },
  }
  dap.defaults.fallback.force_external_terminal = true

  for _, dap_opt in ipairs {
    "user.dap.python",
    "user.dap.go",
    "user.dap.cpp",
    "user.dap.java",
  } do
    local opt_status_ok, fault = pcall(require, dap_opt)
    if not opt_status_ok then
      vim.api.nvim_err_writeln("Failed to load " .. dap_opt .. "\n\n" .. fault)
    end
  end
end

return M
