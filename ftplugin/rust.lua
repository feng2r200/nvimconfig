local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    L = {
      name = "Rust",
      r = { "<cmd>RustRunnables<Cr>", "Runnables" },
      m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
      c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
      p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
      d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
      v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
      R = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "Reload Workspace",
      },
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

