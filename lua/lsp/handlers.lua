local M = {}

M.on_attach = function(client, bufnr)
  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")

  client.resolved_capabilities.document_formatting = false

  local status_signature, signature = pcall(require, "lsp_signature")
  if status_signature then
    signature.on_attach(client)
  end

  local status_illuminate, illuminate = pcall(require, "illuminate")
  if status_illuminate then
    illuminate.on_attach(client)
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
M.capabilities.textDocument.completion.completionItem.resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" }, }

local status_ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok_cmp_lsp then
  M.capabilities = cmp_lsp.update_capabilities(M.capabilities)
end

return M
