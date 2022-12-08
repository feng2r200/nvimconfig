return {
  root_dir = function()
    return vim.fs.dirname(vim.fs.find({ ".git", ".env" }, { upward = true })[1])
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
    },
  },
}
