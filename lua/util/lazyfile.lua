-- LazyFile event for better lazy loading
-- This creates a simple custom event that triggers when a file is loaded

-- Create LazyFile autocmd group
local lazyfile_group = vim.api.nvim_create_augroup("LazyFile", { clear = true })

-- Set up autocmds that will trigger User LazyFile event
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
  group = lazyfile_group,
  callback = function(args)
    -- Trigger User LazyFile event
    vim.api.nvim_exec_autocmds("User", { 
      pattern = "LazyFile",
      data = args,
    })
  end,
})

-- Also create the event mapping if lazy supports it
local ok, lazy_config = pcall(require, "lazy.core.config")
if ok and lazy_config.spec and lazy_config.spec.plugins then
  -- Try to register with lazy's event system if possible
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile" })
  end)
end