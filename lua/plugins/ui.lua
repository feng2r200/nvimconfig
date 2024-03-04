return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
  },

  { "goolord/alpha-nvim", enabled = false },

  { "nvimdev/dashboard-nvim", enabled = false },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      "junegunn/fzf",
    },
    opts = {
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        should_preview_cb = function(bufnr, _)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
        tabc = "",
        ptogglemode = "z,",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
    config = function()
      vim.cmd([[
      hi BqfPreviewBorder guifg=#F2CDCD ctermfg=71
      hi link BqfPreviewRange Search
      ]])
    end,
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
          ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
          ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
          ["gf"] = cb("goto_file"), -- Open the file in a new split in previous tabpage
          ["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
          ["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
          ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
          ["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
        },
        file_panel = {
          ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
          ["<up>"] = cb("prev_entry"),
          ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
          ["o"] = cb("select_entry"),
          ["<Space>"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
          ["S"] = cb("stage_all"), -- Stage all entries.
          ["U"] = cb("unstage_all"), -- Unstage all entries.
          ["r"] = cb("restore_entry"), -- Restore entry to the state on the left side.
          ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
          ["<tab>"] = cb("select_next_entry"),
          ["<s-tab>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
          ["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        file_history_panel = {
          ["g!"] = cb("options"), -- Open the option panel
          ["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
          ["y"] = cb("copy_hash"), -- Copy the commit hash of the entry under the cursor
          ["zR"] = cb("open_all_folds"),
          ["zM"] = cb("close_all_folds"),
          ["j"] = cb("next_entry"),
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"),
          ["<up>"] = cb("prev_entry"),
          ["<cr>"] = cb("select_entry"),
          ["o"] = cb("select_entry"),
          ["<tab>"] = cb("select_next_entry"),
          ["<s-tab>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        option_panel = {
          ["<tab>"] = cb("select"),
          ["q"] = cb("close"),
        },
      }
    end,
  },
}
