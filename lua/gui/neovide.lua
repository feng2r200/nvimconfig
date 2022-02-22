if vim.g.neovide then
    local bind = require("kit.bind")
    local map_cmd = bind.map_cmd
    print("enter neovide")

    vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font:h12]])
    vim.g.neovide_refresh_rate=140
    vim.g.neovide_transparency=0.8
    vim.g.neovide_input_use_logo=true
    vim.g.neovide_cursor_antialiasing=false

    local neovide_mapping = {
        ["n|∆"] = map_cmd('<A-j>'),
        ["n|˚"] = map_cmd('<A-k>'),
        ["n|¬"] = map_cmd('<A-l>'),
        ["n|Ô"] = map_cmd('<A-S-j>'),
        ["n|"] = map_cmd('<A-S-k>'),
        ["n|¡"] = map_cmd('<A-1>'),
        ["n|¶"] = map_cmd('<A-7>'),
    }

    bind.nvim_load_mapping(neovide_mapping)
end

