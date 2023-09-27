local api = require("utils.api")

local M = {}

M.lazy = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "vue",
}

M.lspconfig = {
    server = "vuels",
    config = api.path.generate_relative_path("./vuels"),
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "vue" },
    formatter = {
        exe = "prettier",
        args = {},
        enable = true,
    },
    linter = {},
}

return M
