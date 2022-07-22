return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        special = {
          reload = "require",
        },
      },
      diagnostics = { globals = { "vim", "packer_plugins", "hs" }, },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
          ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000
      },
      hint = {
        enable = true,
        arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
        await = true,
        paramName = "Disable", -- "All", "Literal", "Disable"
        paramType = false,
        semicolon = "Disable", -- "All", "SameLine", "Disable"
        setType = true,
      },
      telemetry = {enable = false}
    },
  },
}
