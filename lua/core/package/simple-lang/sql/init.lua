local M = {}

M.lazy = {}

M.mason = {
    "sql-formatter",
}

M.treesitter = {
    "sql",
}

M.lspconfig = {
    server = "sqlls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "sql" },
    formatter = {
        exe = "sql-formatter",
        args = {
            "-l=postgresql",
        },
        enable = true,
    },
    linter = {},
}

return M
