local lang = {}
local conf = require('modules.lang.config')

lang['rust-lang/rust.vim'] = {opt = true, ft = "rust"}
lang['simrat39/rust-tools.nvim'] = {
    opt = true,
    ft = "rust",
    config = conf.rust_tools
}
lang['iamcco/markdown-preview.nvim'] = {
    opt = true,
    ft = "markdown",
    run = 'cd app && yarn install'
}
lang['mfussenegger/nvim-jdtls'] = {
    opt = true,
    ft = "java"
}
return lang
