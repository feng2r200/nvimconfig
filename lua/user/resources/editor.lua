local Util = require "user.util"
local Icons = require "user.core.icons"

return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
    keys = {
      {
        "<leader>ve",
        function()
          require("neo-tree.command").execute { toggle = true, position = "left", dir = require("user.util").get_root() }
        end,
        desc = "Explorer (root dir)",
        remap = true,
      },
      {
        "<leader>vE",
        function()
          require("neo-tree.command").execute {
            toggle = true,
            position = "float",
            dir = Util.get_root(),
          }
        end,
        desc = "Explorer Float (root dir)",
      },
    },
    opts = require "user.resources.config.neo_tree",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "neo-tree"
          vim.cmd [[set showtabline=0]]
        end
      end
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "johmsalas/text-case.nvim" },
    },
    keys = {
      {
        "<Space>b",
        function()
          require("telescope.builtin").buffers(require("telescope.themes").get_dropdown { previewer = false })
        end,
        desc = "Search Buffers",
      },
      { "<Space><tab>", "<cmd>e#<cr>", desc = "Prev buffer" },
      {
        "gd",
        "<cmd> lua require('telescope.builtin').lsp_definitions()<cr>",
        desc = "Show the definition of current symbol",
      },
      {
        "gy",
        "<cmd> lua require('telescope.builtin').lsp_type_definitions()<cr>",
        desc = "Declaration of current symbol",
      },
      {
        "gh",
        "<cmd> lua require('telescope.builtin').lsp_references()<cr>",
        desc = "Search references",
      },
      {
        "gi",
        "<cmd> lua require('telescope.builtin').lsp_implementations()<cr>",
        desc = "Implementation of current symbol",
      },
      {
        "<leader>fd",
        "<cmd> lua require('telescope.builtin').diagnostics()<cr>",
        desc = "Search diagnostics",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_ivy { hidden = true })
        end,
        desc = "Search files",
      },
      {
        "<leader>fm",
        "<cmd> lua require('telescope.builtin').marks()<cr>",
        desc = "Search marks",
      },
      {
        "<leader>fr",
        "<cmd> lua require('telescope.builtin').registers()<cr>",
        desc = "Search registers",
      },
      {
        "<leader>fs",
        "<cmd> lua require('telescope.builtin').lsp_document_symbols()<cr>",
        desc = "Search symbols",
      },
      {
        "<leader>fw",
        function()
          require("telescope.builtin").live_grep(require("telescope.themes").get_ivy { hidden = true })
        end,
        desc = "Search Text",
      },
      {
        "<leader>fj",
        "<cmd> lua require('telescope.builtin').jumplist()<cr>",
        desc = "Search jump list",
      },
    },
    config = function()
      local actions = require "telescope.actions"

      -- disable preview binaries
      local previewers = require "telescope.previewers"
      local Job = require "plenary.job"
      local new_maker = function(filepath, bufnr, opts)
        filepath = vim.fn.expand(filepath)
        Job:new({
          command = "file",
          args = { "--mime-type", "-b", filepath },
          on_exit = function(j)
            local mime_type = vim.split(j:result()[1], "/")[1]
            if mime_type == "text" then
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
              -- maybe we want to write something to the buffer here
              vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
              end)
            end
          end,
        }):sync()
      end

      require("telescope").setup {
        defaults = {
          sort_mru = true,
          sort_lastused = true,
          pickers = { buffers = { sort_lastused = true } },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = new_maker,

          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          dynamic_preview_title = true,
          hl_result_eol = true,
          path_display = { "truncate" },
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = {
            ".git/",
            "target/",
            "docs/",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "gradle/",
            "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
          },
          results_title = "",
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" },

          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-c>"] = actions.close,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
            },
          },
        },
        extensions = {
          -- fzf syntax
          -- Token	Match type	Description
          -- sbtrkt	fuzzy-match	Items that match sbtrkt
          -- 'wild'	exact-match (quoted)	Items that include wild
          -- ^music	prefix-exact-match	Items that start with music
          -- .mp3$	suffix-exact-match	Items that end with .mp3
          -- !fire	inverse-exact-match	Items that do not include fire
          -- !^music	inverse-prefix-exact-match	Items that do not start with music
          -- !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }

      require("telescope").load_extension "fzf"
      require("telescope").load_extension "notify"

      require("textcase").setup {}
      require("telescope").load_extension "textcase"
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = { enabled = false }, -- enabling this will show WhichKey when pressing z= to select spelling suggestions

        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      operators = {
        gc = "Comments",
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
      triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      local keymaps = {
        ["<leader>d"] = { name = "+Debug" },
        ["<leader>t"] = { name = "+Terminal" },
        ["<leader>v"] = { name = "+View" },
        ["<leader>f"] = { name = "+File" },
        ["<leader>l"] = { name = "+LSP" },
        ["<leader>s"] = { name = "+Search & Replace" },
      }
      wk.register(keymaps)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "]c",
        function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end,
        desc = "Next git hunk",
        expr = true,
      },
      {
        "[c",
        function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end,
        desc = "Previous git hunk",
        expr = true,
      },
      { "<leader>gb", "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>", desc = "Show blame" },
      { "<leader>gd", "<cmd>lua require 'gitsigns'.diffthis()<cr>", desc = "Diff this" },
      { "<leader>gD", "<cmd>lua require 'gitsigns'.diffthis('~')<cr>", desc = "Diff this" },
      { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview git hunk" },
      { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset hunk" },
      { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset buffer" },
      { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
      { "<leader>gt", "<cmd>lua require 'gitsigns'.setqflist()<cr>", desc = "Quickfix show hunks" },
      { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
    },
    opts = {
      signs = {
        add = { text = Icons.gitsigns.add },
        change = { text = Icons.gitsigns.change },
        delete = { text = Icons.gitsigns.delete },
        topdelhfe = { text = Icons.gitsigns.topdelhfe },
        changedelete = { text = Icons.gitsigns.changedelete },
        untracked = { text = Icons.gitsigns.untracked },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        ignore_whitespace = true,
        delay = 300,
      },
      current_line_blame_formatter_opts = {
        relative_time = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      diff_opts = { internal = true },
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      trouble = true,
      yadm = {
        enable = false,
      },
    },
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes_denylist = {
        "help",
        "dirvish",
        "fugitive",
        "alpha",
        "Outline",
        "packer",
        "norg",
        "DoomInfo",
        "toggleterm",
        "NvimTree",
        "neo-tree",
        "dashboard",
        "TelescopePrompt",
        "TelescopeResult",
        "DressingInput",
        "neo-tree-popup",
        "",
      },
      delay = 200,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async", event = "BufReadPost" },
    opts = {
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  … %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
      open_fold_hl_timeout = 0,
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = false,
        ft_ignore = { "neo-tree", "Outline" },
        segments = {
          {
            -- line number
            text = { " ", builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          { text = { "%s" }, click = "v:lua.ScSa" }, -- Sign
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" }, -- Fold
        },
      }
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
          if vim.bo.filetype == "neo-tree" then
            vim.opt_local.statuscolumn = ""
          end

          if vim.bo.filetype == "Outline" then
            vim.opt_local.statuscolumn = ""
          end
        end,
      })
    end,
  },

  {
    "aserowy/tmux.nvim",
    lazy = false,
    keys = {
      { "<C-h>", "<cmd> lua require('tmux').move_left()<cr>", remap = true },
      { "<C-j>", "<cmd> lua require('tmux').move_bottom()<cr>", remap = true },
      { "<C-k>", "<cmd> lua require('tmux').move_top()<cr>", remap = true },
      { "<C-l>", "<cmd> lua require('tmux').move_right()<cr>", remap = true },
      { "<M-h>", "<cmd> lua require('tmux').resize_left()<cr>", remap = true },
      { "<M-j>", "<cmd> lua require('tmux').resize_bottom()<cr>", remap = true },
      { "<M-k>", "<cmd> lua require('tmux').resize_top()<cr>", remap = true },
      { "<M-l>", "<cmd> lua require('tmux').resize_right()<cr>", remap = true },
    },
    opts = {
      copy_sync = {
        enable = false,
      },
      navigation = {
        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,
        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
      },
      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = true,
        -- sets resize steps for x axis
        resize_step_x = 2,
        -- sets resize steps for y axis
        resize_step_y = 2,
      },
    },
  },

  {
    "phaazon/hop.nvim",
    event = { "BufNewFile", "BufReadPost" },
    branch = "v2",
    keys = {
      {
        "<Space>f",
        function()
          require("hop").hint_char1 {
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
          }
        end,
        mode = "n",
        desc = "Find char after cursor",
      },
      {
        "<Space>F",
        function()
          require("hop").hint_char1 {
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
          }
        end,
        mode = "n",
        desc = "Find char before cursor",
      },
      {
        "<Space>f",
        function()
          require("hop").hint_char1 {
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
            inclusive_jump = true,
          }
        end,
        mode = "o",
        desc = "Find char after cursor",
      },
      {
        "<Space>F",
        function()
          require("hop").hint_char1 {
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            inclusive_jump = true,
          }
        end,
        mode = "o",
        desc = "Find char before cursor",
      },
      {
        "<Space>t",
        function()
          require("hop").hint_char1 {
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
          }
        end,
        mode = "",
        desc = "Jump tail after cursor",
      },
      {
        "<Space>T",
        function()
          require("hop").hint_char1 {
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
          }
        end,
        mode = "",
        desc = "Jump tail before cursor",
      },
      { "<Space>j", "<cmd>HopLine<cr>", desc = "Jump line" },
      { "<Space>k", "<cmd>HopLine<cr>", desc = "Jump line" },
      { "<Space>w", "<cmd>HopWord<cr>", desc = "Jump word" },
      { "<Space>s", "<cmd>HopChar1<cr>", desc = "Jump Char" },
    },
    config = function()
      require("hop").setup {}
    end,
  },

  { "antoinemadec/FixCursorHold.nvim", event = { "BufRead", "BufNewFile" } },
}
