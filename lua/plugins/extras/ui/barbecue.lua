return {

  -- VS Code like winbar
  {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      attach_navic = true,
      show_navic = true,

      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      show_dirname = true,
    },
  },
}
