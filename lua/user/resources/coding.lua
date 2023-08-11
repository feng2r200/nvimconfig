local Icon = require "user.core.icons"

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local types = require "luasnip.util.types"

      require("luasnip").config.set_config {
        history = false,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "●", "Comment" } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { Icon.ui.BigUnfilledCircle, "Comment" } },
            },
          },
        },
        ext_base_prio = 300,
        ext_prio_increase = 1,
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ft_func = function()
          return vim.split(vim.bo.filetype, ".", true)
        end,
      }

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").load { paths = { vim.fn.stdpath "config" .. "/my-snippets" } }

      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },

  {
    "danymat/neogen",
    opt = {
      snippet_engine = "luasnip",
      enabled = true, --if you want to disable Neogen
      input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    },
  },

  {
    "windwp/nvim-autopairs",
    opts = {
      enable_check_bracket_line = false,
      ignored_next_char = "[%w%.]",
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "andersevenrud/cmp-tmux",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-cmdline",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"
      local luasnip = require "luasnip"

      local check_backspace = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      ---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
      ---@param dir number 1 for forward, -1 for backward; defaults to 1
      ---@return boolean true if a jumpable luasnip field is found while inside a snippet
      local function jumpable(dir)
        local win_get_cursor = vim.api.nvim_win_get_cursor
        local get_current_buf = vim.api.nvim_get_current_buf

        local function inside_snippet()
          -- for outdated versions of luasnip
          if not luasnip.session.current_nodes then
            return false
          end

          local node = luasnip.session.current_nodes[get_current_buf()]
          if not node then
            return false
          end

          local snip_begin_pos, snip_end_pos = node.parent.snippet.mark:pos_begin_end()
          local pos = win_get_cursor(0)
          pos[1] = pos[1] - 1 -- LuaSnip is 0-based not 1-based like nvim for rows
          return pos[1] >= snip_begin_pos[1] and pos[1] <= snip_end_pos[1]
        end

        ---sets the current buffer's luasnip to the one nearest the cursor
        ---@return boolean true if a node is found, false otherwise
        local function seek_luasnip_cursor_node()
          -- for outdated versions of luasnip
          if not luasnip.session.current_nodes then
            return false
          end

          local pos = win_get_cursor(0)
          pos[1] = pos[1] - 1
          local node = luasnip.session.current_nodes[get_current_buf()]
          if not node then
            return false
          end

          local snippet = node.parent.snippet
          local exit_node = snippet.insert_nodes[0]

          -- exit early if we're past the exit node
          if exit_node then
            local exit_pos_end = exit_node.mark:pos_end()
            if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
              snippet:remove_from_jumplist()
              luasnip.session.current_nodes[get_current_buf()] = nil

              return false
            end
          end

          node = snippet.inner_first:jump_into(1, true)
          while node ~= nil and node.next ~= nil and node ~= snippet do
            local n_next = node.next
            local next_pos = n_next and n_next.mark:pos_begin()
            local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
              or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

            -- Past unmarked exit node, exit early
            if n_next == nil or n_next == snippet.next then
              snippet:remove_from_jumplist()
              luasnip.session.current_nodes[get_current_buf()] = nil

              return false
            end

            if candidate then
              luasnip.session.current_nodes[get_current_buf()] = node
              return true
            end

            local ok
            ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
            if not ok then
              snippet:remove_from_jumplist()
              luasnip.session.current_nodes[get_current_buf()] = nil

              return false
            end
          end

          -- No candidate, but have an exit node
          if exit_node then
            -- to jump to the exit node, seek to snippet
            luasnip.session.current_nodes[get_current_buf()] = snippet
            return true
          end

          -- No exit node, exit from snippet
          snippet:remove_from_jumplist()
          luasnip.session.current_nodes[get_current_buf()] = nil
          return false
        end

        if dir == -1 then
          return inside_snippet() and luasnip.jumpable(-1)
        else
          return inside_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable()
        end
      end

      local hl_group = {
        CmpItemKindCrate = { fg = "#F64D00" },
        CmpItemKindTmux = { fg = "#CA42F0" },
        CmpItemKindTs = { fg = "#6CC644" },

        PmenuSel = { bg = "#282C34", fg = "NONE" },
        Pmenu = { fg = "#C5CDD9", bg = "#22252A" },

        CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
        CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", bold = true },
        CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },
        CmpItemMenu = { fg = "#C792EA", bg = "NONE", italic = true },

        CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
        CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
        CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },

        CmpItemKindText = { fg = "#C3E88D", bg = "#9FBD73" },
        CmpItemKindEnum = { fg = "#C3E88D", bg = "#9FBD73" },
        CmpItemKindKeyword = { fg = "#C3E88D", bg = "#9FBD73" },

        CmpItemKindConstant = { fg = "#FFE082", bg = "#D4BB6C" },
        CmpItemKindConstructor = { fg = "#FFE082", bg = "#D4BB6C" },
        CmpItemKindReference = { fg = "#FFE082", bg = "#D4BB6C" },

        CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
        CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
        CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
        CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
        CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },

        CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
        CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },

        CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
        CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
        CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },

        CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
        CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
        CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },

        CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
        CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
        CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
      }

      for k, v in pairs(hl_group) do
        vim.api.nvim_set_hl(0, k, v)
      end

      local source_menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA]",
        path = "[PATH]",
        tmux = "[TMUX]",
        luasnip = "[SNIP]",
        vsnip = "[SNIP]",
        treesitter = "[TS]",
        emoji = "[Emoji]",
        calc = "[Calc]",
        spell = "[Spell]",
        cmp_tabnine = "[TN]",
        rg = "[RG]",
      }

      local duplicates = {
        nvim_lsp = 4,
        cmp_tabnine = 3,
        luasnip = 2,
        vsnip = 2,
        path = 2,
        rg = 1,
        buffer = 1,
        tmux = 1,
        nvim_lua = 0,
        treesitter = 0,
      }

      local source_hl_group = {
        tmux = "CmpItemKindTmux",
        treesitter = "CmpItemKindTs",
        crates = "CmpItemKindCrate",
      }

      local cmp_config = {
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = lspkind.cmp_format {
              before = function(ety, item)
                item.kind_hl_group = source_hl_group[ety.source.name] or ""

                item.menu = (source_menu)[ety.source.name]
                item.dup = duplicates[ety.source.name] or 0
                return item
              end,
            }(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            return kind
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          keyword_length = 1,
        },
        experimental = {
          ghost_text = true,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:Visual,Search:None",
            col_offset = -3,
            side_padding = 0,
          },
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = { name = "custom" },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", group_index = 0, keyword_length = 1 },
          { name = "cmp_tabnine", group_index = 1 },
          { name = "crates", group_index = 1 },
          { name = "nvim_lua", group_index = 1 },
          { name = "luasnip", group_index = 2, keyword_length = 2 },
          { name = "vsnip", group_index = 2, keyword_length = 2 },
          { name = "buffer", group_index = 3, keyword_length = 3 },
          { name = "path", group_index = 3 },
          { name = "tmux", group_index = 3, keyword_length = 3 },
          { name = "rg", group_index = 3, keyword_length = 3 },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-c>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif jumpable(1) then
              luasnip.jump(1)
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        matching = {
          disallow_fuzzy_matching = false,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            require("cmp-under-comparator").under,
            cmp.config.compare.order,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
          },
        },
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
      }

      cmp.setup(cmp_config)

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline("?", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = {
          { name = "dap" },
        },
      })
      cmp.setup.filetype("java", {
        completion = {
          keyword_length = 2,
        },
      })

      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done { map_char = { tex = "" } })
    end,
  },

  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring {}
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    event = { "InsertEnter" },
    dependencies = "nvim-lspconfig",
  },

  {
    "glepnir/lspsaga.nvim",
    lazy = true,
    config = function()
      require("lspsaga").setup({})
    end,
  },
}
