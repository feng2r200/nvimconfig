require("user.utils.utils").on_attach(function(client, buffer)
  require("user.config.lsp.navic").attach(client, buffer)
  require("user.config.lsp.inlayhints").attach(client, buffer)
  require("user.config.lsp.highlight").attach(client, buffer)
  require("user.config.lsp.signature").attach(client, buffer)

  client.server_capabilities.document_formatting = false
end)

-- diagnostics
for name, icon in pairs(require("user.utils.icons").diagnostics) do
  local function firstUpper(s)
    return s:sub(1, 1):upper() .. s:sub(2)
  end
  name = "DiagnosticSign" .. firstUpper(name)
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
vim.diagnostic.config(require("user.config.lsp.diagnostics")["on"])

local servers = require "user.config.lsp.servers"
local ext_capabilites = vim.lsp.protocol.make_client_capabilities()
ext_capabilites.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
ext_capabilites.textDocument.completion.completionItem.snippetSupport = true
ext_capabilites.textDocument.completion.completionItem.preselectSupport = true
ext_capabilites.textDocument.completion.completionItem.insertReplaceSupport = true
ext_capabilites.textDocument.completion.completionItem.labelDetailsSupport = true
ext_capabilites.textDocument.completion.completionItem.deprecatedSupport = true
ext_capabilites.textDocument.completion.completionItem.commitCharactersSupport = true
ext_capabilites.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
ext_capabilites.textDocument.completion.completionItem.resolveSupport =
  { properties = { "documentation", "detail", "additionalTextEdits" } }

local capabilities = require("user.util").capabilities(ext_capabilites)

local function setup(server)
  if servers[server] and servers[server].disabled then
    return
  end
  local server_opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
    flags = { debounce_text_changes = 150 },
  }, servers[server] or {})
  require("lspconfig")[server].setup(server_opts)
end

local available = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

local ensure_installed = {}
for server, server_opts in pairs(servers) do
  if server_opts then
    if not vim.tbl_contains(available, server) then
      setup(server)
    else
      ensure_installed[#ensure_installed + 1] = server
    end
  end
end

require("mason-lspconfig").setup { ensure_installed = ensure_installed }
require("mason-lspconfig").setup_handlers { setup }
