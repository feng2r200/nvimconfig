return {
  on_attach = mivim.lsp.disable_formatting,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
				globals = { "vim", "packer_plugins", "hs" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
          ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
        },
      },
      telemetry = {enable = false}
    },
  },
}
