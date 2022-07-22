local M = {}

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

local function lsp_highlight_document(client, bufnr)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client, bufnr)
end

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end
  navic.attach(client, bufnr)
end

local function attach_signature(client, bufnr)
  local status_signature, signature = pcall(require, "lsp_signature")
  if not status_signature then
    return
  end
  signature.on_attach(client, bufnr)
end

M.on_attach = function(client, bufnr)
  lsp_highlight_document(client)
  attach_navic(client, bufnr)
  attach_signature(client, bufnr)

  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")

  client.resolved_capabilities.document_formatting = false

  if client.name == "pyright" then
    if client.server_capabilities.inlayHintProvider then
      require("lsp-inlayhints").setup_autocmd(bufnr)
    end
  end

  if client.name == "jdt.ls" then
    vim.lsp.codelens.refresh()
    require("jdtls.dap").setup_dap_main_class_configs()
  end
end

return M
