local servers = {
  "cssls",
  "cssmodules_ls",
  "emmet_ls",
  "html",
  "jdtls",
  "jsonls",
  "solc",
  "sumneko_lua",
  "sqls",
  "tflint",
  "terraformls",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "clangd",
  "rust_analyzer",
  "taplo",
  "lemminx",
  "marksman",
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

local enhance_server_opts = {
  ["clangd"]        = "user.lsp.settings.clangd",
  ["emmet_ls"]      = "user.lsp.settings.emmet_ls",
  ["jsonls"]        = "user.lsp.settings.jsonls",
  ["pyright"]       = "user.lsp.settings.pyright",
  ["rust_analyzer"] = "user.lsp.settings.rust",
  ["solc"]          = "user.lsp.settings.solc",
  ["sqls"]          = "user.lsp.settings.sqls",
  ["sumneko_lua"]   = "user.lsp.settings.sumneko_lua",
  ["tsserver"]      = "user.lsp.settings.tsserver",
  ["yamlls"]        = "user.lsp.settings.yamlls",
}

local lsp_handlers = require("user.lsp.handlers")
for _, server in pairs(servers) do
  opts = {
    on_attach = lsp_handlers.on_attach,
    capabilities = lsp_handlers.capabilities,
    flags = { debounce_text_changes = 150 },
  }

  server = vim.split(server, "@")[1]

  if server == "jdtls" then
    goto continue
  end

  if server == "rust_analyzer" then
    local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
    if not rust_tools_status_ok then
      return
    end

    local status_rust, rust_opts = pcall(require, enhance_server_opts[server])
    if not status_rust then
      goto continue
    end

    rust_opts = vim.tbl_deep_extend("force", rust_opts, opts)
    rust_tools.setup(rust_opts)
    goto continue
  end

  if enhance_server_opts[server] then
    local status_enhance, enhance_opts = pcall(require, enhance_server_opts[server])
    if not status_enhance then
      goto continue
    end
    opts = vim.tbl_deep_extend("force", enhance_opts, opts)
  end

  lspconfig[server].setup(opts)
  ::continue::
end

-- TODO: add something to installer later
-- require("lspconfig").motoko.setup {}
