local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    l = {
      r = { "<cmd>RustRunnables<Cr>", "RustRunnables" },
      m = { "<cmd>RustExpandMacro<Cr>", "RustExpandMacro" },
      c = { "<cmd>RustOpenCargo<Cr>", "RustOpenCargo" },
      p = { "<cmd>RustParentModule<Cr>", "RustParentModule" },
      v = { "<cmd>RustViewCrateGraph<Cr>", "RustViewCrateGraph" },
      R = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "RustReloadWorkspace",
      },
    },

    d = {
      r = { "<cmd>RustDebuggables<Cr>", "RustDebuggables" },
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

