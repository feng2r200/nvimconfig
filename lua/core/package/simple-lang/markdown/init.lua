local M = {}

M.lazy = {
    {
        "davidgranstrom/nvim-markdown-preview",
        ft = { "markdown" },
        config = function()
            --  github
            --  solarized-light
            --  solarized-dark
            vim.g.nvim_markdown_preview_theme = "solarized-light"
            vim.g.nvim_markdown_preview_format = "markdown"
        end,
    },
    {
        "askfiy/nvim-picgo",
        lazy = true,
        ft = { "markdown" },
        config = function()
            require("nvim-picgo").setup()
            ---
            vim.keymap.set(
                { "n" },
                "<leader>uc",
                "<cmd>lua require('nvim-picgo').upload_clipboard()<cr>",
                { silent = true, desc = "Upload image from clipboard" }
            )
            vim.keymap.set(
                { "n" },
                "<leader>uf",
                "<cmd>lua require('nvim-picgo').upload_imagefile()<cr>",
                { silent = true, desc = "Upload image from disk file" }
            )
        end,
    },
}

M.mason = {
    "prettier",
}

M.treesitter = {
    "markdown",
}

M.lspconfig = {
    server = "grammarly",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.efm_ls = {
    filetype = { "markdown", "markdown.mdx" },
    formatter = {
        exe = "prettier",
        args = {
            "--stdin",
            "--stdin-filepath",
            "${INPUT}",
            "${--range-start:charStart}",
            "${--range-end:charEnd}",
            "${--tab-width:=2}",
        },
        enable = true,
    },
    linter = {},
}

return M
