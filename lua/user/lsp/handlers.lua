local M = {}

-- TODO: backfill this to template
M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
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
  }

  vim.diagnostic.config(config)

end

local function lsp_keymaps(bufnr)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

M.on_attach = function(client, bufnr)
  -- if client.name == "tsserver" or client.name == "clangd" then
    -- client.resolved_capabilities.document_formatting = false
  -- end
  lsp_keymaps(bufnr)

  require "lsp_signature".on_attach()
  require("illuminate").on_attach(client)
  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
return M
