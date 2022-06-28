local status_dapui_ok, dapui = pcall(require, "dapui")
local status_dap_ok, dap = pcall(require, "dap")
if not status_dapui_ok or not status_dap_ok then
  return
end

local function debug_open()
  dapui.open()
  vim.api.nvim_command("DapVirtualTextEnable")
end

local function debug_close()
  vim.api.nvim_command("DapVirtualTextDisable")
  dap.repl.close()
  dapui.close()
  vim.api.nvim_command("bdelete! term:")   -- close debug temrinal
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
        "repl",
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
