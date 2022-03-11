local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
    opt = true,
    event = "BufReadPre",
    config = conf.nvim_lsp
}
completion["williamboman/nvim-lsp-installer"] = {
    opt = true,
    after = "nvim-lspconfig"
}
completion["stevearc/aerial.nvim"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.aerial,
}
completion["ray-x/lsp_signature.nvim"] = {opt = true, after = "nvim-lspconfig"}
completion["lukas-reineke/cmp-under-comparator"] = {opt = true}
completion["hrsh7th/nvim-cmp"] = {
    opt = false,
    config = conf.cmp,
    event = "InsertEnter",
    requires = {
        {"saadparwaiz1/cmp_luasnip", after = "LuaSnip"},
        {"hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip"},
        {"hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp"},
        {"andersevenrud/cmp-tmux", after = "cmp-nvim-lua"},
        {"hrsh7th/cmp-path", after = "cmp-tmux"},
        {"hrsh7th/cmp-buffer", after = "cmp-path"},
    }
}
completion["L3MON4D3/LuaSnip"] = {
    opt = true,
    config = conf.luasnip,
    requires = "rafamadriz/friendly-snippets"
}
completion["windwp/nvim-autopairs"] = {
    opt = true,
    event = "InsertEnter",
    config = conf.autopairs
}

return completion
