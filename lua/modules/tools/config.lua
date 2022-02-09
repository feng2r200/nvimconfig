local config = {}

function config.telescope()
    vim.cmd([[packadd sqlite.lua]])
    vim.cmd([[packadd telescope-dap.nvim]])
    vim.cmd([[packadd telescope-file-browser.nvim]])
    vim.cmd([[packadd telescope-frecency.nvim]])
    vim.cmd([[packadd telescope-fzf-native.nvim]])
    vim.cmd([[packadd telescope-media-files.nvim]])
    vim.cmd([[packadd telescope-project.nvim]])
    vim.cmd([[packadd telescope-zoxide]])
    vim.cmd([[packadd telescope-ui-select.nvim]])

    require("telescope").setup({
        defaults = {
            prompt_prefix = "🔭 ",
            selection_caret = " ",
            layout_config = {
                horizontal = {prompt_position = "bottom", results_width = 0.6},
                vertical = {mirror = false}
            },
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = {},
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = {"absolute"},
            winblend = 0,
            border = {},
            borderchars = {
                "─", "│", "─", "│", "╭", "╮", "╯", "╰"
            },
            color_devicons = true,
            use_less = true,
            set_env = {["COLORTERM"] = "truecolor"},
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case"
            },
            frecency = {
                show_scores = true,
                show_unindexed = true,
                ignore_patterns = {"*.git/*", "*/tmp/*"},
            },
            media_files = {
                filetypes = {"png", "webp", "jpg", "jpeg", "pdf"},
                find_cmd = "fd"
            },
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                }
            }
        }
    })

    require("telescope").load_extension("dap")
    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("frecency")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("media_files")
    require("telescope").load_extension("project")
    require("telescope").load_extension("zoxide")
    require("telescope").load_extension("ui-select")

end

function config.trouble()
    require("trouble").setup({
        position = "bottom",
        height = 10,
        width = 50,
        icons = true,
        mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "",
        fold_closed = "",
        action_keys = {
            -- key mappings for actions in the trouble list
            -- map to {} to remove a mapping, for example:
            -- close = {},
            close = "q",
            cancel = "<esc>",
            refresh = "r",
            jump = {"<cr>", "<tab>"},
            open_split = {"<c-x>"},
            open_vsplit = {"<c-v>"},
            open_tab = {"<c-t>"},
            jump_close = {"o"},
            toggle_mode = "m",
            toggle_preview = "P",
            hover = "K",
            preview = "p",
            close_folds = {"zM", "zm"},
            open_folds = {"zR", "zr"},
            toggle_fold = {"zA", "za"},
            previous = "k",
            next = "j"
        },
        indent_lines = true,
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_fold = false,
        signs = {
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠",
        },
        use_lsp_diagnostic_signs = false,
    })
end

function config.sniprun()
    require("sniprun").setup({
        selected_interpreters = {}, -- " use those instead of the default for the current filetype
        repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
        repl_disable = {}, -- " disable REPL-like behavior for the given interpreters
        interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>
        -- " you can combo different display modes as desired
        display = {
            "Classic", -- "display results in the command-line  area
            "VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
            "VirtualTextErr", -- "display error results as virtual text
            -- "TempFloatingWindow",      -- "display results in a floating window
            "LongTempFloatingWindow", -- "same as above, but only long results. To use with VirtualText__
            -- "Terminal"                 -- "display results in a vertical split
        },
        -- " miscellaneous compatibility/adjustement settings
        inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
        -- " to workaround sniprun not being able to display anything

        borders = "shadow", -- " display borders around floating windows
        -- " possible values are 'none', 'single', 'double', or 'shadow'
    })
end

function config.wilder()
    vim.cmd([[
    call wilder#setup({'modes': [':', '/', '?']})
    call wilder#set_option('use_python_remote_plugin', 0)

    call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'use_python': 0,'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter()}),wilder#vim_search_pipeline(), [wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({'draw': [{_, x -> ' ' . x}]})])])

    call wilder#set_option('renderer', wilder#renderer_mux({':': wilder#popupmenu_renderer({'highlighter': wilder#lua_fzy_highlighter(), 'left': [wilder#popupmenu_devicons()], 'right': [' ', wilder#popupmenu_scrollbar()]}), '/': wilder#wildmenu_renderer({'highlighter': wilder#lua_fzy_highlighter()})}))
    ]])
end

function config.filetype()
	require("filetype").setup({
		overrides = {
			shebang = {
				-- Set the filetype of files with a dash shebang to sh
				dash = "sh",
			},
		},
	})
end

return config
