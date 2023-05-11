local M = {
  "feline-nvim/feline.nvim",
  after = "nvim-web-devicons",
}

M.config = function()
  local status_ok, feline = pcall(require, "feline")
  if not status_ok then
    return
  end

  local C = require "user.utils.colors"
  local status_kit = require "user.utils.status"
  local hl = status_kit.hl
  local provider = status_kit.provider
  local conditional = status_kit.conditional

  --[[ if vim.fn.has "nvim-0.8" == 1 then ]]
  --[[   feline.winbar.setup { ]]
  --[[     disable = { filetypes = { "^NvimTree$", "^neo%-tree$", "^dashboard$", "^alpha$", "^Outline$", "^aerial$" } }, ]]
  --[[     theme = hl.group("Winbar", { fg = C.fg, bg = C.bg1 }), ]]
  --[[     components = { ]]
  --[[       active = { ]]
  --[[         { ]]
  --[[           { provider = provider.gps(), enabled = conditional.gps_available() }, ]]
  --[[         }, ]]
  --[[       }, ]]
  --[[     }, ]]
  --[[   } ]]
  --[[ end ]]

  local icons = require("user.utils.icons")

  feline.setup {
    disable = { filetypes = { "^NvimTree$", "^neo%-tree$", "^dashboard$", "^alpha$", "^Outline$", "^aerial$" } },
    theme = hl.group("StatusLine", { fg = C.fg, bg = C.bg1 }),
    components = {
      active = {
        {
          { provider = provider.spacer(), hl = hl.mode() },
          { provider = provider.spacer(1) },
          { provider = "git_branch", hl = hl.fg("Conditional", { fg = C.purple, style = "bold" }), icon = icons.git.Git .. " " },
          { provider = provider.spacer(2), enabled = conditional.git_available },
          {
            provider = { name = "file_type", opts = { filetype_icon = true, case = "lowercase" } },
            enabled = conditional.has_filetype,
          },
          { provider = provider.spacer(2), enabled = conditional.has_filetype },
          { provider = "git_diff_added", hl = hl.fg("GitSignsAdd", { fg = C.green }), icon = " " .. icons.git.Add .. " " },
          { provider = "git_diff_changed", hl = hl.fg("GitSignsChange", { fg = C.orange }), icon = " " .. icons.git.Mod .. " " },
          { provider = "git_diff_removed", hl = hl.fg("GitSignsDelete", { fg = C.red }), icon = " " .. icons.git.Remove .. " " },
          { provider = provider.spacer(2), enabled = conditional.git_changed },
          { provider = "diagnostic_errors", hl = hl.fg("DiagnosticError", { fg = C.red }), icon = " " .. icons.diagnostics.Error .. " " },
          { provider = "diagnostic_warnings", hl = hl.fg("DiagnosticWarn", { fg = C.orange }), icon = " " .. icons.diagnostics.Warning .. " " },
          { provider = "diagnostic_info", hl = hl.fg("DiagnosticInfo", { fg = C.fd }), icon = " " .. icons.diagnostics.Information .. " " },
          { provider = "diagnostic_hints", hl = hl.fg("DiagnosticHint", { fg = C.yellow }), icon = " " .. icons.diagnostics.Hint .. " " },
        },
        {
          --[[ { provider = provider.lsp_progress, enabled = conditional.bar_width() }, ]]
          {
            provider = provider.lsp_client_names(true),
            short_provider = provider.lsp_client_names(),
            enabled = conditional.bar_width(),
            icon = " " .. icons.misc.Lsp .. " ",
          },
          { provider = provider.spacer(2) },
          { provider = "position" },
          { provider = provider.spacer(2) },
          { provider = "line_percentage" },
          { provider = provider.spacer() },
          { provider = "scroll_bar", hl = hl.fg("TypeDef", { fg = C.yellow }) },
          { provider = provider.spacer(2) },
          { provider = provider.spacer(), hl = hl.mode() },
        },
      },
    },
  }
end

return M
