local api = require("utils.api")

local M = {}

M.lazy = {}

M.mason = {
    "clang-format",
    "cpptools",
}

M.treesitter = {
    "c",
    "cpp",
    "cmake",
}

M.lspconfig = {
    server = "clangd",
    config = api.path.generate_relative_path("./clangd"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.efm_ls = {
    filetype = { "c", "cpp" },
    formatter = {
        exe = "clang_format",
        args = {
            "--style",
            "{IndentWidth: 4}",
        },
        enable = true,
    },
    linter = {},
}

return M
