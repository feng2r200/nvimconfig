local status_ok, nvim_lsp = pcall(require, "lspconfig")
if not status_ok then
  vim.notify "lspconfig not loaded"
  return
end

local languages = require "user.lsp.languages"
local lsp_handlers = require "user.lsp.handlers"

local servers = languages.servers
local enhance_server_opts = languages.enhance_server_opts

for _, server in pairs(servers) do
  local opts = {
    on_attach = lsp_handlers.on_attach,
    capabilities = lsp_handlers.capabilities,
    flags = { debounce_text_changes = 150 },
  }

  server = vim.split(server, "@")[1]

  if server == "jdtls" then
    goto continue
  end

  if server == "pyright" then
    opts = vim.tbl_deep_extend("force", {
      before_init = function(_, config)
        config.settings.python.pythonPath = lsp_handlers.get_python_path(config.root_dir)
      end,
    }, opts)
    goto setup
  end

  if server == "rust_analyzer" then
    vim.cmd [[packadd rust-tools.nvim]]
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

  ::setup::
  if enhance_server_opts[server] then
    local status_enhance, enhance_opts = pcall(require, enhance_server_opts[server])
    if not status_enhance then
      goto continue
    end
    opts = vim.tbl_deep_extend("force", enhance_opts, opts)
  end

  nvim_lsp[server].setup(opts)
  ::continue::
end
