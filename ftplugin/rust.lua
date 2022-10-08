local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    l = {
      a = { "<cmd>lua require('rust-tools').hover_actions.hover_actions()<cr>", "Code Action" },
      d = { "<cmd>RustOpenExternalDocs<cr>", "Open External Docs" },
      r = { "<cmd>lua require('rust-tools').runnables.runnables()<cr>", "RustRunnables" },
      m = { "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>", "RustExpandMacro" },
      c = { "<cmd>lua require'rust-tools'.open_cargo_toml.open_cargo_toml()<cr>", "RustOpenCargo" },
      p = { "<cmd>lua require'rust-tools'.parent_module.parent_module()<cr>", "RustParentModule" },
      R = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<cr>",
        "RustReloadWorkspace",
      },
    },

    d = {
      r = { "<cmd>RustDebuggables<cr>", "RustDebuggables" },
    },
  }

  wk.register(mappings, {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  })
end

local notify_filter = vim.notify
vim.notify = function(msg, ...)
  if msg:match "message with no corresponding" then
    return
  end

  notify_filter(msg, ...)
end

