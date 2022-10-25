vim.opt_local.foldcolumn = "1"
vim.opt_local.foldenable = true
vim.opt_local.signcolumn = "yes"

local notify_filter = vim.notify
vim.notify = function(msg, ...)
  if msg:match "warning: multiple different client offset_encodings detected for buffer, this is not supported yet" then
    return
  end

  notify_filter(msg, ...)
end
