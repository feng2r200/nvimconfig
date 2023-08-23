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

return require("user.util").capabilities(ext_capabilites)

