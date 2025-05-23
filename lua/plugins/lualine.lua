-- Plugin: Lualine

return {

  -----------------------------------------------------------------------------
  -- Statusline plugin with many customizations.
  -- NOTE: This extends
  -- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
  {
    "lualine.nvim",
    init = function()
      vim.g.qf_disable_statusline = true
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local icons = LazyVim.config.icons

      local function is_plugin_window()
        return vim.bo.buftype ~= ""
      end

      local function is_file_window()
        return vim.bo.buftype == ""
      end

      local function is_not_prompt()
        return vim.bo.buftype ~= "prompt"
      end

      local function is_min_width(min)
        if vim.o.laststatus > 2 then
          return vim.o.columns > min
        end
        return vim.fn.winwidth(0) > min
      end

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "starter" } },
        },
        extensions = { "man", "lazy" },
        sections = {
          lualine_a = {
            {
              function()
                return "▊"
              end,
              padding = 0,
              separator = "",
              color = function()
                local hl = is_file_window() and "Statement" or "Function"
                return { fg = Snacks.util.color(hl) }
              end,
            },
            -- Readonly/zoomed/hash symbol.
            {
              padding = { left = 1, right = 0 },
              separator = "",
              cond = is_file_window,
              function()
                if vim.bo.buftype == "" and vim.bo.readonly then
                  return icons.status.filename.readonly
                elseif vim.t["zoomed"] then
                  return icons.status.filename.zoomed
                end
                return ""
              end,
            },
          },
          lualine_b = {
            {
              "branch",
              cond = is_file_window,
              icon = "", --  
              padding = 1,
              on_click = function()
                vim.cmd([[Telescope git_branches]])
              end,
            },
            LazyVim.lualine.root_dir(),
            {
              require("util.lualine").plugin_title(),
              padding = { left = 0, right = 1 },
              cond = is_plugin_window,
            },
            {
              function()
                return vim.bo.modified and vim.bo.buftype == "" and icons.status.filename.modified or " "
              end,
              icon_only = true,
              padding = { left = 1, right = 0 },
              cond = is_file_window,
            },
          },
          lualine_c = {
            {
              LazyVim.lualine.pretty_path(),
              color = { fg = "#D7D7BC" },
              cond = is_file_window,
              on_click = function()
                vim.g.structure_status = not vim.g.structure_status
                require("lualine").refresh()
              end,
            },
            {
              separator = "",
              padding = { left = 0, right = 1 },
              function()
                return "#" .. vim.b["toggle_number"]
              end,
              cond = function()
                return vim.bo.buftype == "terminal"
              end,
            },
            {
              separator = "",
              function()
                if vim.fn.win_gettype() == "loclist" then
                  return vim.fn.getloclist(0, { title = 0 }).title
                end
                return vim.fn.getqflist({ title = 0 }).title
              end,
              cond = function()
                return vim.bo.filetype == "qf"
              end,
              padding = { left = 1, right = 0 },
            },

            -- Whitespace trails
            {
              require("util.lualine").trails(),
              cond = is_file_window,
              padding = { left = 1, right = 0 },
              color = function()
                return { fg = Snacks.util.color("Identifier") }
              end,
            },

            {
              "diagnostics",
              symbols = {
                error = icons.status.diagnostics.error,
                warn = icons.status.diagnostics.warn,
                info = icons.status.diagnostics.info,
                hint = icons.status.diagnostics.hint,
              },
            },

            {
              function()
                if vim.v.hlsearch == 0 then
                  return ""
                end

                local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 10 })
                if not ok or next(result) == nil or result.current == 0 then
                  return ""
                end

                local denominator = math.min(result.total, result.maxcount)
                return string.format("/%s [%d/%d]", vim.fn.getreg("/"), result.current, denominator)
              end,
              separator = "",
              padding = { left = 1, right = 0 },
            },

            {
              function()
                return require("nvim-navic").get_location()
              end,
              padding = { left = 1, right = 0 },
              cond = function()
                return vim.g.structure_status
                  and is_min_width(100)
                  and package.loaded["nvim-navic"]
                  and require("nvim-navic").is_available()
              end,
              on_click = function()
                vim.g.structure_status = not vim.g.structure_status
                require("lualine").refresh()
              end,
            },
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- Diff (git)
            {
              "diff",
              symbols = {
                added = icons.status.git.added,
                modified = icons.status.git.modified,
                removed = icons.status.git.removed,
              },
              padding = 1,
              cond = function()
                return is_file_window() and is_min_width(70)
              end,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              on_click = function()
                vim.cmd([[DiffviewFileHistory %]])
              end,
            },
            -- showcmd
            {
              function()
                ---@diagnostic disable-next-line: undefined-field
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"]
                  ---@diagnostic disable-next-line: undefined-field
                  and require("noice").api.status.command.has()
              end,
              color = function()
                return { fg = Snacks.util.color("Statement") }
              end,
            },
            -- showmode
            {
              function()
                ---@diagnostic disable-next-line: undefined-field
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"]
                  ---@diagnostic disable-next-line: undefined-field
                  and require("noice").api.status.mode.has()
              end,
              color = function()
                return { fg = Snacks.util.color("Constant") }
              end,
            },
						-- dap status
						-- stylua: ignore
						{
							function() return '  ' .. require('dap').status() end,
							cond = function () return package.loaded['dap'] and require('dap').status() ~= '' end,
							color = function() return { fg = Snacks.util.color('Debug') } end,
						},
          },
          lualine_y = {
            {
              require("util.lualine").filemedia(),
              padding = 1,
              cond = function()
                return is_min_width(70)
              end,
              on_click = function()
                vim.cmd([[Telescope filetypes]])
              end,
            },
          },
          lualine_z = {
            {
              function()
                if is_file_window() then
                  return "%l/%2c%4p%%"
                end
                return "%l/%L"
              end,
              cond = is_not_prompt,
              padding = 1,
            },
          },
        },
        inactive_sections = {
          lualine_a = {
            {
              "filetype",
              icon_only = true,
              colored = false,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              LazyVim.lualine.pretty_path({ length = 3 }),
              padding = { left = 1, right = 0 },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              function()
                return vim.bo.filetype
              end,
              cond = is_file_window,
            },
          },
        },
      }

      -- Show code structure in statusline.
      -- Allow it to be overriden for some buffer types (see autocmds).
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },
}
