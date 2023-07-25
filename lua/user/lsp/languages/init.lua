local M = {}

M.servers = {
  "bashls",
  "clangd",
  "cssls",
  "cssmodules_ls",
  "emmet_ls",
  "html",
  "jdtls",
  "jsonls",
  "lemminx",
  "sumneko_lua",
  "marksman",
  "pyright",
  "rust_analyzer",
  "solc",
  "sqlls",
  "taplo",
  "terraformls",
  "tflint",
  "tsserver",
}

local languages_path = "user.lsp.languages"
M.enhance_server_opts = {
  ["clangd"] = languages_path .. ".clangd",
  ["emmet_ls"] = languages_path .. ".emmet_ls",
  ["jsonls"] = languages_path .. ".jsonls",
  ["pyright"] = languages_path .. ".pyright",
  ["rust_analyzer"] = languages_path .. ".rust",
  ["solc"] = languages_path .. ".solc",
  ["sqlls"] = languages_path .. ".sqls",
  ["sumneko_lua"] = languages_path .. ".sumneko_lua",
  ["tsserver"] = languages_path .. ".tsserver",
}

return M
