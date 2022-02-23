local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

function autocmd.load_autocmds()
    local definitions = {
        bufs = {
            {"BufWritePre", "/tmp/*", "setlocal noundofile"},
            {"BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile"},
            {"BufWritePre", "MERGE_MSG", "setlocal noundofile"},
            {"BufWritePre", "*.tmp", "setlocal noundofile"},
            {"BufWritePre", "*.bak", "setlocal noundofile"},
            {"BufReadPost", "*", [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]]}
        },

        wins = {
            -- Highlight current line only on focused window
            {"WinEnter,BufEnter,InsertLeave", "*", [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],},
            {"WinLeave,BufLeave,InsertEnter", "*", [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],},
            -- Force write shada on leaving nvim
            {"VimLeave", "*", [[if has('nvim') | wshada! | else | wviminfo! | endif]]},
            -- Check if file changed when its window is focus, more eager than 'autoread'
            {"FocusGained", "* checktime"},
            -- Equalize window dimensions when resizing vim window
            {"VimResized", "*", [[tabdo wincmd =]]}
        },

        ft = {
            {"FileType", "dashboard", "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2",},
            {"BufNewFile,BufRead", "*.toml", " setf toml"},
            {"FileType", "make", "set noexpandtab shiftwidth=8 softtabstop=0"},
            {"FileType", "java", "set noexpandtab tabstop=4, shiftwidth=4 softtabstop=4"},
            {"FileType", "go,rust", "setlocal tabstop=4 shiftwidth=4"},
            {"FileType", "javascript,typescript,html", "setlocal tabstop=2 shiftwidth=2"},
            {"FileType", "*", [[setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]},
            {"FileType", "dap-repl", "lua require('dap.ext.autocompl').attach()"},
            { "FileType", "markdown", "set wrap" },
        },
        yank = {
            {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]]}
        }
    }

    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
