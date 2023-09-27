local M = {}

M.lazy = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "json",
    "jsonc",
}

M.lspconfig = {
    server = "jsonls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "json", "jsonc" },
    formatter = {
        exe = "prettier",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
