require("user.util").on_attach(function(client, buffer)
  require("user.resources.config.lsp.navic").attach(client, buffer)
  require("user.resources.config.lsp.inlayhints").attach(client, buffer)
  require("user.resources.config.lsp.highlight").attach(client, buffer)
  require("user.resources.config.lsp.signature").attach(client, buffer)

  client.server_capabilities.document_formatting = false

  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc()")
  vim.api.nvim_buf_set_option(buffer, "formatexpr", "v:lua.vim.lsp.formatexpr()")
end)

-- Set underline highlighting for Lsp references
vim.cmd "hi! LspReferenceText cterm=underline gui=underline"
vim.cmd "hi! LspReferenceWrite cterm=underline gui=underline"
vim.cmd "hi! LspReferenceRead cterm=underline gui=underline"

-- diagnostics
for name, icon in pairs(require("user.core.icons").diagnostics) do
  local function firstUpper(s)
    return s:sub(1, 1):upper() .. s:sub(2)
  end
  name = "DiagnosticSign" .. firstUpper(name)
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
vim.diagnostic.config(require("user.resources.config.lsp.diagnostics")["on"])

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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local servers = require "user.resources.config.lsp.servers"
local function setup(server)
  if servers[server] and servers[server].disabled then
    if server == "rust_analyzer" then
      local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
      if not rust_tools_status_ok then
        return
      end

      local server_opts = servers[server].opts(capabilities)
      rust_tools.setup(server_opts)
      return
    end

    return
  end

  local server_opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
    flags = { debounce_text_changes = 150 },
  }, servers[server] or {})

  require("lspconfig")[server].setup(server_opts)
end

for server, _ in pairs(servers) do
  setup(server)
end

require("mason-lspconfig").setup {}
