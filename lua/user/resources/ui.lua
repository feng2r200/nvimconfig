local Util = require "user.util"
local Icon = require "user.core.icons"

return {
  {
    "rcarriga/nvim-notify",
    enabled = false,
    opts = {
      icons = {
        ERROR = Icon.diagnostics.Error .. " ",
        INFO = Icon.diagnostics.Information .. " ",
        WARN = Icon.diagnostics.Warning .. " ",
      },
      timeout = 3000,
      background_colour = "#000000",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      if not Util.has "noice.nvim" then
        Util.on_very_lazy(function()
          vim.notify = require "notify"
        end)
      end
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "]b", "<cmd>BufferLineCycleNext<cr>", "BufferLineCycleNext" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", "BufferLineCyclePrev" },
      { ">b", "<cmd>BufferLineMoveNext<cr>", "BufferLineMoveNext" },
      { "<b", "<cmd>BufferLineMovePrev<cr>", "BufferLineMovePrev" },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "both",
        close_command = "Bdelete! %d",
        indicator = { style = "underline" },
        offsets = {
          { filetype = "neo-tree", text = "EXPLORER", text_align = "center", separator = true },
          { filetype = "NvimTree", text = "EXPLORER", text_align = "center", separator = true },
          { filetype = "Outline", text = "OUTLINE", text_align = "center", separator = true },
        },
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
          if buf.name:match "%.md" then
            return vim.fn.fnamemodify(buf.name, ":t:r")
          end
        end,
        max_name_length = 20,
        max_prefix_length = 15,
        tab_size = 23,
        diagnostics = false, --| "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        show_buffer_icons = true, --| false, -- disable filetype icons for buffers
        show_buffer_close_icons = true, --| false,
        show_close_icon = true, --| false,
        show_tab_indicators = true, -- | false,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = "thin",
        enforce_regular_tabs = false, --| true,
        always_show_bufferline = true, -- | false,
        sort_by = "directory", -- ,'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        hover = {
          enabled = true,
          delay = 0,
          reveal = { "close" },
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      float = true,
      separator = "bubble", -- bubble | triangle
      ---@type any
      colorful = true,
    },
    config = function(_, opts)
      local lualine_config = require "user.resources.config.lualine"
      lualine_config.setup(opts)
      lualine_config.load()
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      char = "▏",
      context_char = "▏",
      show_end_of_line = false,
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
      use_treesitter = true,
      filetype_exclude = {
        "help",
        "startify",
        "aerial",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "alpha",
        "neo-tree",
        "", -- for all buffers without a file type
      },
      buftype_exclude = {
        "terminal",
        "nofile",
        "lsp-installer",
        "lspinfo",
      },
    },
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "echasnovski/mini.indentscope",
    lazy = true,
    enabled = true,
    opts = {
      symbol = "▏",
      options = { try_as_border = false },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "startify",
          "aerial",
          "dashboard",
          "packer",
          "neogitstatus",
          "lazy",
          "mason",
          "NvimTree",
          "Trouble",
          "alpha",
          "neo-tree",
          "", -- for all buffers without a file type
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },

  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = true,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      kinds = Icon.kinds,
    },
  },

  {
    "akinsho/toggleterm.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>t", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
      { "<leader>Th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" },
      { "<leader>Tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" },
    },
    opts = {
      open_mapping = nil,
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = 2,
      start_in_insert = true,
      direction = "float",
      autochdir = false,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
      close_on_exit = true,
      shell = vim.o.shell,
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy", "!neo-tree" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        win_options = { winblend = 0 },
      },
      select = { telescope = Util.telescope_theme "cursor" },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = "  󰄼" },
          search_up = { icon = "  " },
          lua = { icon = "  " },
        },
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = false },
        signature = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
        },
      },
    },
  },

  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = true },
    },
    opts = {
      animation = { enable = true, duration = 150, fps = 60 },
      autowidth = { enable = true },
    },
    keys = {
      { "<C-w>z", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" },
      { "<C-w>_", "<cmd>WindowsMaximizeVertically", desc = "Max vertically window" },
      { "<C-w>|", "<cmd>WindowsMaximizeHorizontally", desc = "Max horizontally window" },
      { "<C-w>=", "<cmd>WindowsEqualize", desc = "Equalize window" },
    },
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = false
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gc", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
    },
    opts = {
      diff_binaries = false, -- Show diffs for binaries
      enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
      use_icons = true, -- Requires nvim-web-devicons
      icons = { -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      view = {
        -- Configure the layout and behavior of different types of views.
        -- Available layouts:
        --  'diff1_plain'
        --    |'diff2_horizontal'
        --    |'diff2_vertical'
        --    |'diff3_horizontal'
        --    |'diff3_vertical'
        --    |'diff3_mixed'
        --    |'diff4_mixed'
        -- For more info, see ':h diffview-config-view.x.layout'.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_horizontal",
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff4_mixed",
          disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        win_config = {
          position = "left", -- One of 'left', 'right', 'top', 'bottom'
          width = 35, -- Only applies when position is 'left' or 'right'
          height = 10, -- Only applies when position is 'top' or 'bottom'
        },
        listing_style = "tree", -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
          flatten_dirs = true, -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
              max_count = 512,
              follow = true,
              all = false, -- Include all refs under 'refs/' including HEAD
              merges = false, -- List only merge commits
              no_merges = false, -- List no merge commits
              reverse = false, -- List commits in reverse order
            },
            multi_file = {
              diff_merges = "first-parent",
              max_count = 128,
              all = false, -- Include all refs under 'refs/' including HEAD
              merges = false, -- List only merge commits
              no_merges = false, -- List no merge commits
              reverse = false, -- List commits in reverse order
            },
          },
        },
      },
      default_args = { -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {}, -- See ':h diffview-config-hooks'
    },
    config = function(_, opts)
      local cb = require("diffview.config").diffview_callback

      opts.key_bindings = {
        disable_defaults = false, -- Disable the default key bindings
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        view = {
          ["<tab>"] = cb "select_next_entry", -- Open the diff for the next file
          ["<s-tab>"] = cb "select_prev_entry", -- Open the diff for the previous file
          ["gf"] = cb "goto_file", -- Open the file in a new split in previous tabpage
          ["<C-w><C-f>"] = cb "goto_file_split", -- Open the file in a new split
          ["<C-w>gf"] = cb "goto_file_tab", -- Open the file in a new tabpage
          ["<leader>e"] = cb "focus_files", -- Bring focus to the files panel
          ["<leader>b"] = cb "toggle_files", -- Toggle the files panel.
        },
        file_panel = {
          ["j"] = cb "next_entry", -- Bring the cursor to the next file entry
          ["<down>"] = cb "next_entry",
          ["k"] = cb "prev_entry", -- Bring the cursor to the previous file entry.
          ["<up>"] = cb "prev_entry",
          ["<cr>"] = cb "select_entry", -- Open the diff for the selected entry.
          ["o"] = cb "select_entry",
          ["<Space>"] = cb "toggle_stage_entry", -- Stage / unstage the selected entry.
          ["S"] = cb "stage_all", -- Stage all entries.
          ["U"] = cb "unstage_all", -- Unstage all entries.
          ["r"] = cb "restore_entry", -- Restore entry to the state on the left side.
          ["R"] = cb "refresh_files", -- Update stats and entries in the file list.
          ["<tab>"] = cb "select_next_entry",
          ["<s-tab>"] = cb "select_prev_entry",
          ["gf"] = cb "goto_file",
          ["<C-w><C-f>"] = cb "goto_file_split",
          ["<C-w>gf"] = cb "goto_file_tab",
          ["i"] = cb "listing_style", -- Toggle between 'list' and 'tree' views
          ["f"] = cb "toggle_flatten_dirs", -- Flatten empty subdirectories in tree listing style.
          ["<leader>e"] = cb "focus_files",
          ["<leader>b"] = cb "toggle_files",
        },
        file_history_panel = {
          ["g!"] = cb "options", -- Open the option panel
          ["<C-A-d>"] = cb "open_in_diffview", -- Open the entry under the cursor in a diffview
          ["y"] = cb "copy_hash", -- Copy the commit hash of the entry under the cursor
          ["zR"] = cb "open_all_folds",
          ["zM"] = cb "close_all_folds",
          ["j"] = cb "next_entry",
          ["<down>"] = cb "next_entry",
          ["k"] = cb "prev_entry",
          ["<up>"] = cb "prev_entry",
          ["<cr>"] = cb "select_entry",
          ["o"] = cb "select_entry",
          ["<tab>"] = cb "select_next_entry",
          ["<s-tab>"] = cb "select_prev_entry",
          ["gf"] = cb "goto_file",
          ["<C-w><C-f>"] = cb "goto_file_split",
          ["<C-w>gf"] = cb "goto_file_tab",
          ["<leader>e"] = cb "focus_files",
          ["<leader>b"] = cb "toggle_files",
        },
        option_panel = {
          ["<tab>"] = cb "select",
          ["q"] = cb "close",
        },
      }
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    event = { "BufReadPost" },
    keys = {
      { "<leader>vo", "<cmd>SymbolsOutline<cr>", desc = "Symbols outline" },
    },
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false,
      position = "right",
      relative_width = true,
      width = 25,
      auto_close = false,
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      preview_bg_highlight = "Pmenu",
      keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "gh",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
        File = { icon = Icon.kinds.File, hl = "TSURI" },
        Module = { icon = Icon.kinds.Module, hl = "TSNamespace" },
        Namespace = { icon = Icon.kinds.Folder, hl = "TSNamespace" },
        Package = { icon = Icon.kinds.Package, hl = "TSNamespace" },
        Class = { icon = Icon.kinds.Class, hl = "TSType" },
        Method = { icon = Icon.kinds.Method, hl = "TSMethod" },
        Property = { icon = Icon.kinds.Property, hl = "TSMethod" },
        Field = { icon = Icon.kinds.Field, hl = "TSField" },
        Constructor = { icon = Icon.kinds.Constructor, hl = "TSConstructor" },
        Enum = { icon = Icon.kinds.Enum, hl = "TSType" },
        Interface = { icon = Icon.kinds.Interface, hl = "TSType" },
        Function = { icon = Icon.kinds.Function, hl = "TSFunction" },
        Variable = { icon = Icon.kinds.Variable, hl = "TSConstant" },
        Constant = { icon = Icon.kinds.Constant, hl = "TSConstant" },
        String = { icon = Icon.kinds.String, hl = "TSString" },
        Number = { icon = Icon.kinds.Number, hl = "TSNumber" },
        Boolean = { icon = Icon.kinds.Boolean, hl = "TSBoolean" },
        Array = { icon = Icon.kinds.Array, hl = "TSConstant" },
        Object = { icon = Icon.kinds.Object, hl = "TSType" },
        Key = { icon = Icon.kinds.Key, hl = "TSType" },
        Null = { icon = Icon.kinds.Null, hl = "TSType" },
        EnumMember = { icon = Icon.kinds.EnumMember, hl = "TSField" },
        Struct = { icon = Icon.kinds.Struct, hl = "TSType" },
        Event = { icon = Icon.kinds.Event, hl = "TSType" },
        Operator = { icon = Icon.kinds.Operator, hl = "TSOperator" },
        TypeParameter = { icon = Icon.kinds.TypeParameter, hl = "TSParameter" },
      },
    },
  },

  {
    "folke/trouble.nvim",
    event = { "BufRead" },
    opts = {
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
        jump = { "<cr>", "<tab>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "o" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
      },
      indent_lines = true,
      auto_open = false,
      auto_close = false,
      auto_preview = true,
      auto_fold = false,
      signs = {
        error = Icon.diagnostics.Error,
        warning = Icon.diagnostics.Warning,
        hint = Icon.diagnostics.Hint,
        information = Icon.diagnostics.Information,
        other = Icon.diagnostics.Question,
      },
      use_lsp_diagnostic_signs = false,
    },
  },

  {
    "gaborvecsei/memento.nvim",
    keys = {
      { "<leader>fe", "<cmd>lua require('memento').toggle()<cr>", desc = "Search history" },
    },
  },

  {
    "mbbill/undotree",
    event = "BufReadPost",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>vu", "<cmd>UndotreeToggle<cr>", desc = "UndoTree toggle" },
    },
  },
}
