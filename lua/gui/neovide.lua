if vim.g.neovide then
    vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font:h12]])
    vim.g.neovide_refresh_rate=140
    vim.g.neovide_transparency=0.8
    vim.g.neovide_input_use_logo=true
    vim.g.neovide_cursor_antialiasing=false

    vim.api.nvim_set_keymap("n", "∆", '<A-j>', {})
    vim.api.nvim_set_keymap("n", "˚", '<A-k>', {})
    vim.api.nvim_set_keymap("n", "¬", '<A-l>', {})
    vim.api.nvim_set_keymap("n", "Ô", '<A-S-j>', {})
    vim.api.nvim_set_keymap("n", "", '<A-S-k>', {})
    vim.api.nvim_set_keymap("n", "¡", '<A-1>', {})
    vim.api.nvim_set_keymap("n", "¶", '<A-7>', {})
end

