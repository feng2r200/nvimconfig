local M = {}

M.servers = {
  "bashls",
  "dockerls",
  "jsonls",
  "marksman",
  "cssls",
  "cssmodules_ls",
  "emmet_ls",
  "html",
  "jdtls",
  "solc",
  "sumneko_lua",
  "sqls",
  "tflint",
  "terraformls",
  "tsserver",
  "pyright",
  "yamlls",
  "clangd",
  "rust_analyzer",
  "taplo",
  "lemminx",
}

local languages_path = "user.lsp.languages"
M.enhance_server_opts = {
  ["clangd"] = languages_path .. ".clangd",
  ["emmet_ls"] = languages_path .. ".emmet_ls",
  ["jsonls"] = languages_path .. ".jsonls",
  ["pyright"] = languages_path .. ".pyright",
  ["rust_analyzer"] = languages_path .. ".rust",
  ["solc"] = languages_path .. ".solc",
  ["sqls"] = languages_path .. ".sqls",
  ["sumneko_lua"] = languages_path .. ".sumneko_lua",
  ["tsserver"] = languages_path .. ".tsserver",
  ["yamlls"] = languages_path .. ".yamlls",
}

return M
