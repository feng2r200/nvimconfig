local M = {}

M.lazy = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "html",
}

M.lspconfig = {
    server = "html",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "html" },
    formatter = {
        exe = "prettier",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
