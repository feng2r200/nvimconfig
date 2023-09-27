local api = require("utils.api")

local M = {}

M.lazy = {}

M.mason = {
    "delve",
}

M.treesitter = {
    "go",
    "gomod",
    "gosum",
    "gowork",
}

M.lspconfig = {
    server = "gopls",
    config = {},
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.efm_ls = {
    filetype = { "go" },
    formatter = {
        exe = "gofmt",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
