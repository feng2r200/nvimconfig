local M = {}

M.lazy = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "css",
}

M.lspconfig = {
    server = "cssls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "css", "scss", "less" },
    formatter = {
        exe = "prettier",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
