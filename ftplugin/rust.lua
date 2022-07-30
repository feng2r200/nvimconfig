local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    l = {
      d = { "<cmd>RustOpenExternalDocs<cr>", "Open External Docs" },
      r = { "<cmd>RustRunnables<cr>", "RustRunnables" },
      m = { "<cmd>RustExpandMacro<cr>", "RustExpandMacro" },
      c = { "<cmd>RustOpenCargo<cr>", "RustOpenCargo" },
      p = { "<cmd>RustParentModule<cr>", "RustParentModule" },
      v = { "<cmd>RustViewCrateGraph<cr>", "RustViewCrateGraph" },
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

