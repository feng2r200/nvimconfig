local lang = {}
local conf = require("modules.lang.config")

lang["simrat39/rust-tools.nvim"] = {
    opt = true,
    ft = "rust",
    config = conf.rust_tools,
    requires = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim", opt = true },
        { "mfussenegger/nvim-dap", opt = true },
    },
}

lang["mfussenegger/nvim-jdtls"] = {
    opt = true,
    ft = "java",
}

lang["iamcco/markdown-preview.nvim"] = {
    opt = true,
    ft = "markdown",
    run = "cd app && yarn install"
}

lang["chrisbra/csv.vim"] = {opt = true, ft = "csv"}

return lang
