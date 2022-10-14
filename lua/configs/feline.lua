local status_ok, feline = pcall(require, "feline")
if not status_ok then
  return
end

local C = require "onedark.colors"
local status_kit = require("kit.status")
local hl = status_kit.hl
local provider = status_kit.provider
local conditional = status_kit.conditional

if vim.fn.has "nvim-0.8" == 1 then
  feline.winbar.setup({
    disable = { filetypes = { "^NvimTree$", "^neo%-tree$", "^dashboard$", "^alpha$", "^Outline$", "^aerial$" } },
    theme = hl.group("Winbar", { fg = C.fg, bg = C.bg1 }),
    components = {
      active = {
        {
          { provider = provider.gps(), enabled = conditional.gps_available() },
        }
      }
    }
  })
end

feline.setup({
  disable = { filetypes = { "^NvimTree$", "^neo%-tree$", "^dashboard$", "^alpha$", "^Outline$", "^aerial$" } },
  theme = hl.group("StatusLine", { fg = C.fg, bg = C.bg1 }),
  components = {
    active = {
      {
        { provider = provider.spacer(), hl = hl.mode() },
        { provider = provider.spacer(2) },
        { provider = "git_branch", hl = hl.fg("Conditional", { fg = C.purple, style = "bold" }), icon = " " },
        { provider = provider.spacer(3), enabled = conditional.git_available },
        { provider = { name = "file_type", opts = { filetype_icon = true, case = "lowercase" } }, enabled = conditional.has_filetype },
        { provider = provider.spacer(2), enabled = conditional.has_filetype },
        { provider = "git_diff_added", hl = hl.fg("GitSignsAdd", { fg = C.green }), icon = "  " },
        { provider = "git_diff_changed", hl = hl.fg("GitSignsChange", { fg = C.orange }), icon = " 柳" },
        { provider = "git_diff_removed", hl = hl.fg("GitSignsDelete", { fg = C.red }), icon = "  " },
        { provider = provider.spacer(2), enabled = conditional.git_changed },
        { provider = "diagnostic_errors", hl = hl.fg("DiagnosticError", { fg = C.red }), icon = "  " },
        { provider = "diagnostic_warnings", hl = hl.fg("DiagnosticWarn", { fg = C.orange }), icon = "  " },
        { provider = "diagnostic_info", hl = hl.fg("DiagnosticInfo", { fg = C.fd }), icon = "  " },
        { provider = "diagnostic_hints", hl = hl.fg("DiagnosticHint", { fg = C.yellow }), icon = "  " },
      },
      {
        { provider = provider.lsp_progress, enabled = conditional.bar_width() },
        { provider = provider.lsp_client_names(true), short_provider = provider.lsp_client_names(), enabled = conditional.bar_width(), icon = "   " },
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
})

