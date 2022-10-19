if vim.g.vscode then
  return
end

require("bootstrap")

for _, source in ipairs {
  "core.plugins",
  "core.mappings",
  "core.autocmds",
  "core.options",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end

