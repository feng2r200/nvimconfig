local api = require("utils.api")

local M = {}

M.lazy = {
    {
        "Vimjas/vim-python-pep8-indent",
        ft = { "python" },
    },
}

M.mason = {
    "autopep8",
    "pylint",
    "debugpy",
}

M.treesitter = {
    "python",
    "requirements",
    "htmldjango",
}

M.lspconfig = {
    -- server = "pyright",
    -- config = api.path.generate_relative_path("./pyright"),
    -----
    server = "pylance",
    config = api.path.generate_relative_path("./pylance"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.efm_ls = {
    filetype = { "python" },
    formatter = {
        exe = "autopep8",
        args = {
            "-a",
            "--max-line-length=120",
            "-",
        },
        enable = true,
    },
    linter = {
        exe = "pylint",
        args = {
            "--rcfile=" .. api.path.generate_absolute_path("./linter/pylintrc"),
        },
        enable = false,
    },
}

return M
