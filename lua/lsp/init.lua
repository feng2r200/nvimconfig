local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local status_lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_lsp_installer_ok then
  return
end

local enhance_server_opts = {
  ["clangd"] = require "lsp.settings.clangd",
  ["gopls"] = require "lsp.settings.gopls",
  ["jsonls"] = require "lsp.settings.jsonls",
  ["sqls"] = require "lsp.settings.sqls",
  ["sumneko_lua"] = require "lsp.settings.sumneko_lua",
}

local lsp_handlers = require "lsp.handlers"
local servers = {}
for _, server in ipairs(lsp_installer.get_installed_servers()) do
  if server.name ~= 'jdtls' then
    table.insert(servers, server.name)
  end
end
for _, server in ipairs(servers) do
  local opts = {
    on_attach = lsp_handlers.on_attach,
    capabilities = lsp_handlers.capabilities,
    flags = { debounce_text_changes = 150 },
  }

  if enhance_server_opts[server] then
    local enhance_opts = enhance_server_opts[server]
    opts = vim.tbl_deep_extend("force", enhance_opts, opts)
  end

  lspconfig[server].setup(opts)
end

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
vim.diagnostic.config({
  virtual_text = true,
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

