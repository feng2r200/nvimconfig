local M = {}

M.lazy = {}

M.mason = {
    "shfmt",
}

M.treesitter = {
    "bash",
}

M.lspconfig = {
    server = "bashls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "sh", "zsh" },
    formatter = {
        exe = "shfmt",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
