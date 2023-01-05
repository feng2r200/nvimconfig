local M = {}

M.format_range_operator = function()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, "[")
    local finish = vim.api.nvim_buf_get_mark(0, "]")

    local bfn = vim.api.nvim_get_current_buf()
    vim.lsp.buf.format({
      bufnr = bfn,
      filter = function(c)
        return require("user.utils.lsp").filter_format_lsp_client(c, bfn)
      end,
      range = {
        start,
        finish,
      },
    })
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end

-- 指定格式化 lsp_client
local format_lsp_mapping = {}
format_lsp_mapping["java"] = "jdtls"

format_lsp_mapping["c"] = "clangd"
format_lsp_mapping["cpp"] = "clangd"

M.filter_format_lsp_client = function(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local cn = format_lsp_mapping[filetype] or "null-ls"
  return client.name == cn
end

M.code_hover = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
  elseif vim.fn.expand "%:t" == "Cargo.toml" then
    local crates_status, crates = pcall(require, "crates")
    if crates_status then
      crates.show_popup()
    else
      vim.lsp.buf.hover()
    end
  else
    vim.lsp.buf.hover()
  end
end

return M
