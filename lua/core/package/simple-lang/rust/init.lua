local api = require("utils.api")

local M = {}

M.lazy = {}

M.mason = {}

M.treesitter = {
    "rust",
}

M.lspconfig = {
    server = "rust_analyzer",
    config = api.path.generate_relative_path("./rust_analyzer"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.efm_ls = {
    filetype = { "rust" },
    formatter = {
        exe = "rustfmt",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
