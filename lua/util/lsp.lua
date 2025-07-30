-- LSP utility functions
-- Based on LazyVim's LSP utilities

local M = {}

---@param client_id integer
---@param buffer integer
function M.on_attach(client_id, buffer)
  local client = vim.lsp.get_client_by_id(client_id)
  if not client then
    return
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Buffer local mappings
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
  end

  -- LSP keymaps
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  -- map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
  map("n", "<space>D", vim.lsp.buf.type_definition, "Type definition")
  map("n", "<space>rn", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "gr", vim.lsp.buf.references, "References")

  -- Additional LSP keymaps
  map("n", "<leader>cli", vim.lsp.buf.incoming_calls, "Incoming calls")
  map("n", "<leader>clo", vim.lsp.buf.outgoing_calls, "Outgoing calls")

  -- Format on save if the client supports it
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = buffer,
      callback = function()
        vim.lsp.buf.format({ bufnr = buffer })
      end,
    })
  end

  -- Highlight symbol under cursor
  if client.supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = buffer,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = buffer,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

---@param on_attach fun(client:vim.lsp.Client, buffer:integer)
function M.on_attach_callback(on_attach)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach(client, buffer)
      end
    end,
  })
end

-- Get LSP clients for buffer
---@param buffer integer?
---@return vim.lsp.Client[]
function M.get_clients(buffer)
  buffer = buffer or vim.api.nvim_get_current_buf()
  if vim.fn.has("nvim-0.11") == 1 then
    return vim.lsp.get_clients({ bufnr = buffer })
  else
    ---@diagnostic disable-next-line: deprecated
    return vim.lsp.get_active_clients({ bufnr = buffer })
  end
end

return M

