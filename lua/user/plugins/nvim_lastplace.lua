local M = {
  "ethanholz/nvim-lastplace",
  event = "BufRead",
  disable = true,
}

M.config = function()
  local status_ok, nvim_lastposition = pcall(require, "nvim-lastplace")
  if not status_ok then
    return
  end

  nvim_lastposition.setup({
          lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
          lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
          lastplace_open_folds = true
    }
  )
end

return M
