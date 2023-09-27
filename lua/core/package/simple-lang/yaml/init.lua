local M = {}

M.lazy = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "yaml",
}

M.lspconfig = {
    server = "yamlls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "yaml" },
    formatter = {
        exe = "prettier",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
