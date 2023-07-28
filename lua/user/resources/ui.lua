local Util = require "user.utils.utils"
local Icon = require "user.utils.icons"

return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>n",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      icons = {
        ERROR = Icon.diagnostics.Error .. " ",
        INFO = Icon.diagnostics.Information .. " ",
        WARN = Icon.diagnostics.Warning .. " ",
      },
      timeout = 3000,
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
    opts = {
      options = {
        mode = "buffers",
        numbers = "both",
        diagnostics = false, --| "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        separator_style = "thin",
        enforce_regular_tabs = false, --| true,
        always_show_bufferline = true, -- | false,
        sort_by = "directory", -- ,'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        indicator = { style = "underline" },
        close_command = "Bdelete! %d",
        max_name_length = 20,
        max_prefix_length = 15,
        tab_size = 23,
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
          if buf.name:match "%.md" then
            return vim.fn.fnamemodify(buf.name, ":t:r")
          end
        end,
        offsets = {
          { filetype = "neo-tree", text = "EXPLORER", text_align = "center", separator = true },
          { filetype = "NvimTree", text = "EXPLORER", text_align = "center", separator = true },
          { filetype = "Outline", text = "OUTLINE", text_align = "center", separator = true },
        },
        show_buffer_icons = true, --| false, -- disable filetype icons for buffers
        show_buffer_close_icons = true, --| false,
        show_close_icon = true, --| false,
        show_tab_indicators = true, -- | false,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
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
      local lualine_config = require "user.config.lualine"
      lualine_config.setup(opts)
      lualine_config.load()
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      char = "▏",
      context_char = "▏",
      show_end_of_line = false,
      space_char_blankline = " ",
      show_current_context = true,
      show_trailing_blankline_indent = false,
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
      context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      },
    },
    config = function()
      -- because lazy load indent-blankline so need readd this autocmd
      vim.cmd "autocmd CursorMoved * IndentBlanklineRefresh"
    end,
  },

  {
    "echasnovski/mini.indentscope",
    lazy = true,
    enabled = true,
    version = false,
    -- event = "BufReadPre",
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
      attach_navic = false,
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
    opts = {
      open_mapping = [[<C-t>]],
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
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      highlights = {
        FloatBorder = { link = "ToggleTermBorder" },
        Normal = { link = "ToggleTerm" },
        NormalFloat = { link = "ToggleTerm" },
      },
      winbar = {
        enabled = true,
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
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = true
    end,
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

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = false,
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

  -- noicer ui
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
}
