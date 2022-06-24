mivim.lsp = {}
local conditional_func = mivim.conditional_func

local function lsp_highlight_document(client)
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_document_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.clear_references,
    })
  end
end

mivim.lsp.on_attach = function(client, bufnr)
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

  local aerial_avail, aerial = pcall(require, "aerial")
  conditional_func(aerial.on_attach, aerial_avail, client, bufnr)
  lsp_highlight_document(client)
end

mivim.lsp.capabilities = vim.lsp.protocol.make_client_capabilities()
mivim.lsp.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
mivim.lsp.capabilities.textDocument.completion.completionItem.snippetSupport = true
mivim.lsp.capabilities.textDocument.completion.completionItem.preselectSupport = true
mivim.lsp.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
mivim.lsp.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
mivim.lsp.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
mivim.lsp.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
mivim.lsp.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
mivim.lsp.capabilities.textDocument.completion.completionItem.resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" }, }

function mivim.lsp.server_settings(server_name)
  local server = require("lspconfig")[server_name]
  local opts = { capabilities = vim.tbl_deep_extend("force", mivim.lsp.capabilities, server.capabilities or {}), }
  local old_on_attach = server.on_attach
  local user_on_attach = opts.on_attach
  opts.on_attach = function(client, bufnr)
    conditional_func(old_on_attach, true, client, bufnr)
    mivim.lsp.on_attach(client, bufnr)
    conditional_func(user_on_attach, true, client, bufnr)
  end
  return opts
end

function mivim.lsp.disable_formatting(client)
  client.resolved_capabilities.document_formatting = false
end

return mivim.lsp
