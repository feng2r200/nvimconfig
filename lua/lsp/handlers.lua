local M = {}

M.on_attach = function(client, bufnr)
  mivim.set_mappings(
    {
      n = {
        ["K"] = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details", buffer = bufnr, },
        ["<leader>la"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action", buffer = bufnr, },
        ["<leader>lf"] = { function() vim.lsp.buf.formatting_sync() end, desc = "Format code", buffer = bufnr, },
        ["<leader>lh"] = { function() vim.lsp.buf.signature_help() end, desc = "Signature help", buffer = bufnr, },
        ["<leader>lr"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol", buffer = bufnr, },
        ["gD"] = { function() vim.lsp.buf.declaration() end, desc = "Declaration of current symbol", buffer = bufnr, },
        ["gI"] = { function() vim.lsp.buf.implementation() end, desc = "Implementation of current symbol", buffer = bufnr, },
        ["gd"] = { function() vim.lsp.buf.definition() end, desc = "Show the definition of current symbol", buffer = bufnr, },
        ["gr"] = { function() vim.lsp.buf.references() end, desc = "References of current symbol", buffer = bufnr, },
        ["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics", buffer = bufnr, },
        ["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic", buffer = bufnr, },
        ["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic", buffer = bufnr, },
        ["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics", buffer = bufnr, },
      },
    },
    { buffer = bufnr }
  )

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function() vim.lsp.buf.formatting() end, { desc = "Format file with LSP" })

  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")

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
