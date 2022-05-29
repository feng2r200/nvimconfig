local status_ok, ntag = pcall(require, "nvim-ts-autotag")
if not status_ok then
  vim.notify("autotag not found!")
  return
end

ntag.setup({
    filetypes = {
        "html",
        "xml",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "vue",
    },
})
