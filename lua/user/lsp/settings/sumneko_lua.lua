return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "packer_plugins", "hs" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
          ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
				},
        maxPreload = 100000,
        preloadFileSize = 10000
			},
      telemetry = {enable = false}
		},
	},
}
