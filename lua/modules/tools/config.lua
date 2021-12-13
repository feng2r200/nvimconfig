local config = {}

function config.telescope()
    local home = os.getenv("HOME")

    if not packer_plugins["popup.nvim"].loaded then
        vim.cmd [[packadd popup.nvim]]
    end

    if not packer_plugins["telescope-fzf-native.nvim"].loaded then
        vim.cmd [[packadd telescope-fzf-native.nvim]]
    end

    if not packer_plugins["telescope-project.nvim"].loaded then
        vim.cmd [[packadd telescope-project.nvim]]
    end

    if not packer_plugins["sqlite.lua"].loaded then
        vim.cmd [[packadd sqlite.lua]]
    end

    if not packer_plugins["telescope-frecency.nvim"].loaded then
        vim.cmd [[packadd telescope-frecency.nvim]]
    end

    if not packer_plugins["telescope-media-files.nvim"].loaded then
        vim.cmd [[packadd telescope-media-files.nvim]]
    end

    if not packer_plugins["telescope-zoxide"].loaded then
        vim.cmd [[packadd telescope-zoxide]]
    end

    if not packer_plugins["telescope-dap.nvim"].loaded then
        vim.cmd [[packadd telescope-dap.nvim]]
    end

    require("telescope").setup {
        defaults = {
            prompt_prefix = "🔭 ",
            selection_caret = " ",
            layout_config = {
                horizontal = {prompt_position = "bottom", results_width = 0.6},
                vertical = {mirror = false}
            },
            file_previewer = require "telescope.previewers".vim_buffer_cat.new,
            grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
            qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
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
            set_env = {["COLORTERM"] = "truecolor"}
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
                workspaces = {
                    ["conf"] = home .. "/.config",
                    ["data"] = home .. "/.local/share",
                    ["nvim"] = home .. "/.config/nvim",
                    ["code"] = home .. "/workspace",
                    ["go"] = home .. "/workspace/go",
                    ["rust"] = home .. "/workspace/rust",
                    ["python"] = home .. "/workspace/python",
                    ["leetcode"] = home .. "/workspace/leetcode"
                }
            },
            media_files = {
                filetypes = {"png", "webp", "jpg", "jpeg", "pdf"},
                find_cmd = "fd"
            }
        }
    }

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("project")
    require("telescope").load_extension("frecency")
    require("telescope").load_extension("media_files")
    require("telescope").load_extension("zoxide")
    require("telescope").load_extension("dap")
end

function config.sniprun()
    require "sniprun".setup({
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
            "LongTempFloatingWindow" -- "same as above, but only long results. To use with VirtualText__
            -- "Terminal"                 -- "display results in a vertical split
        },

        -- " miscellaneous compatibility/adjustement settings
        inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
        -- " to workaround sniprun not being able to display anything

        borders = "shadow" -- " display borders around floating windows
        -- " possible values are 'none', 'single', 'double', or 'shadow'
    })
end

function config.wilder()
    vim.cmd [[
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('use_python_remote_plugin', 0)

call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'use_python': 0,'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter()}),wilder#vim_search_pipeline(), [wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({'draw': [{_, x -> ' ' . x}]})])])

call wilder#set_option('renderer', wilder#renderer_mux({':': wilder#popupmenu_renderer({'highlighter': wilder#lua_fzy_highlighter(), 'left': [wilder#popupmenu_devicons()], 'right': [' ', wilder#popupmenu_scrollbar()]}), '/': wilder#wildmenu_renderer({'highlighter': wilder#lua_fzy_highlighter()})}))
]]

end

return config
