---@diagnostic disable: undefined-global
LazyVim.on_very_lazy(function()
  vim.filetype.add({
    extension = {
      gotmpl = "gotmpl",
    },
    pattern = {
      [".*/templates/.*%.ya?ml"] = "helm",
      [".*/templates/.*%.tpl"] = "helm",
      ["helmfile.*%.ya?ml"] = "helm",
    },
  })
end)

return {
  desc = "Helm lang extras, common patterns, without towolf/vim-helm.",
  recommended = function()
    return LazyVim.extras.wants({
      ft = "helm",
      root = { "Chart.yaml" },
    })
  end,

  { import = "lazyvim.plugins.extras.lang.helm" },

  { "towolf/vim-helm", enabled = false },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = "helm",
    },
  },
}
