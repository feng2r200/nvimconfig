local config = {}

function config.onedark()
    local onedark = require("onedark")
    onedark.setup {
        style = "darker",
        transparent = true,
        term_colors = true,
        toggle_style_list = {"darker"},

        code_style = {
            comments = 'italic',
            keywords = 'bold',
            functions = 'bold',
            strings = "none",
            variables = "none",
        }
    }
    onedark.load()
end

function config.lualine()
    local gps = require("nvim-gps")

    local function gps_content()
        if gps.is_available() then
            return gps.get_location()
        else
            return ""
        end
    end
    local mini_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
    }
    local simple_sections = {
        lualine_a = { "mode" },
        lualine_b = { "filetype" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
    }
    local aerial = {
        sections = mini_sections,
        filetypes = { "aerial" },
    }
    local dapui_scopes = {
        sections = simple_sections,
        filetypes = { "dapui_scopes" },
    }

    local dapui_breakpoints = {
        sections = simple_sections,
        filetypes = { "dapui_breakpoints" },
    }

    local dapui_stacks = {
        sections = simple_sections,
        filetypes = { "dapui_stacks" },
    }

    local dapui_watches = {
        sections = simple_sections,
        filetypes = { "dapui_watches" },
    }

    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = "onedark",
            disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
            component_separators = "|",
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { { "branch" }, { "diff" } },
            lualine_c = {
                { "lsp_progress" },
                { gps_content, cond = gps.is_available },
                { require('auto-session-library').current_session_name },
            },
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " " },
                },
            },
            lualine_y = {
                {
                    "filetype",
                    "encoding",
                },
                {
                    "fileformat",
                    icons_enabled = true,
                    symbols = {
                        unix = "LF",
                        dos = "CRLF",
                        mac = "CR",
                    },
                },
            },
            lualine_z = { "progress", "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {
            "quickfix",
            "nvim-tree",
            "toggleterm",
            "fugitive",
            aerial,
            dapui_scopes,
            dapui_breakpoints,
            dapui_stacks,
            dapui_watches,
        },
    })
end

function config.alpha()
    local ascii = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }

    local header = {
        type = "text",
        val = ascii,
        opts = {
            position = "center",
            hl = "AlphaHeader",
        },
    }

    local function button(sc, txt)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

        local opts = {
            position = "center",
            text = txt,
            shortcut = sc,
            cursor = 5,
            width = 36,
            align_shortcut = "right",
            hl = "AlphaButtons",
        }

        return {
            type = "button",
            val = txt,
            on_press = function()
                local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
                vim.api.nvim_feedkeys(key, "normal", false)
            end,
            opts = opts,
        }
    end

    local buttons = {
        type = "group",
        val = {
            button("SPC f n", "  File New"),
            button("SPC f f", "  Find File  "),
            button("SPC f w", "  Find Word  "),
            button("SPC f p", "  Find Project"),
        },
        opts = {
            spacing = 1,
        },
    }

    local section = {
        header = header,
        buttons = buttons,
    }

    require("alpha").setup {
        layout = {
            { type = "padding", val = 5 },
            section.header,
            { type = "padding", val = 2 },
            section.buttons,
        },
        opts = {},
    }
end

function config.nvim_tree()
    require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        ignore_ft_on_setup = { "startify", "dashboard", "alpha" },
        auto_close = true,
        open_on_tab = false,
        hijack_cursor = true,
        update_cwd = false,
        update_to_buf_dir = { enable = false, auto_open = false },
        diagnostics = {
            enable = false,
            icons = { hint = "", info = "", warning = "", error = "" },
        },
        highlight_opened_files = true,
        auto_ignore_ft = { "startify", "dashboard", "alpha" },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        system_open = { cmd = nil, args = {} },
        filters = { dotfiles = false, custom = {} },
        git = { enable = true, ignore = true, timeout = 500 },
        view = {
            width = 40,
            hide_root_folder = false,
            side = "left",
            auto_resize = false,
            mappings = { custom_only = false, list = {} },
            number = false,
            relativenumber = false,
            signcolumn = "yes",
        },
        trash = { cmd = "trash", require_confirm = true },
    })
end

function config.nvim_bufferline()
    require("bufferline").setup({
        options = {
            number = "none",
            modified_icon = "✥",
            buffer_close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 14,
            max_prefix_length = 13,
            tab_size = 20,
            show_buffer_close_icons = true,
            show_buffer_icons = true,
            show_tab_indicators = true,
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
            separator_style = "thin",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "center",
                    padding = 1,
                },
            },
        },
    })
end

function config.todo_comments()
    require("todo-comments").setup({
        keywords = {
            FIX = {
                icon = " ",
                color = "#DC2626",
                alt = {"FIXME", "BUG", "FIXIT", "ISSUE", "!"}
            },
            TODO = {icon = " ", color = "#10B981"},
            HACK = {icon = " ", color = "#7C3AED"},
            WARN = {icon = " ", color = "#FBBF24", alt = {"WARNING", "XXX"}},
            PERF = {icon = " ", color = "#FC9868", alt = {"OPTIM", "PERFORMANCE", "OPTIMIZE"}},
            NOTE = {icon = " ", color = "#2563EB", alt = {"INFO"}}
        }
    })
end

function config.gitsigns()
    require("gitsigns").setup({
        signs = {
            add = {hl = "GitGutterAdd", text = "+"},
            change = {hl = "GitGutterChange", text = "~"},
            delete = {hl = "GitGutterDelete", text = "_"},
            topdelete = {hl = "GitGutterDeleteChange", text = "-"},
            changedelete = {hl = "GitGutterChange", text = "|"}
        },
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,
            ["n ]g"] = {expr = true, '&diff ? \']g\' : \'<cmd>lua require "gitsigns".next_hunk()<CR>\''},
            ["n [g"] = {expr = true, '&diff ? \'[g\' : \'<cmd>lua require "gitsigns".prev_hunk()<CR>\''},
            ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
        },
        watch_gitdir = { interval = 1000, follow_files = true },
        current_line_blame = true,
        current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = { internal = true },
    })
end

function config.indent_blankline()
    vim.opt.termguicolors = true
    vim.opt.list = true
    require("indent_blankline").setup({
        char = "│",
        show_first_indent_level = true,
        filetype_exclude = {
            "startify",
            "dashboard",
            "alpha",
            "dotooagenda",
            "log",
            "lspinfo",
            "lsp-installer",
            "terminal",
            "fugitive",
            "gitcommit",
            "packer",
            "vimwiki",
            "markdown",
            "json",
            "txt",
            "vista",
            "help",
            "todoist",
            "NvimTree",
            "peekaboo",
            "git",
            "TelescopePrompt",
            "undotree",
            "flutterToolsOutline",
            "", -- for all buffers without a file type
        },
        buftype_exclude = { "terminal", "nofile" },
        show_trailing_blankline_indent = false,
        show_current_context = true,
        context_patterns = {
            "class",
            "function",
            "method",
            "block",
            "list_literal",
            "selector",
            "^if",
            "^table",
            "if_statement",
            "while",
            "for",
            "type",
            "var",
            "import",
        },
        space_char_blankline = " ",
    })
    -- because lazy load indent-blankline so need readd this autocmd
    vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
end

return config
