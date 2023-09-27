local api = require("utils.api")

local M = {}

M.lazy = {
    {
        "folke/neodev.nvim",
        priority = 80,
    },
}

M.mason = {
    "stylua",
}

M.treesitter = {
    "lua",
    "luadoc",
}

M.lspconfig = {
    server = "lua_ls",
    config = api.path.generate_relative_path("./lua_ls"),
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "lua" },
    formatter = {
        exe = "stylua",
        args = {
            "--search-parent-directories",
            "--indent-type=Spaces",
            "--indent-width=4",
            "--column-width=80",
            "-",
        },
        enable = true,
    },
    linter = {},
}

return M
