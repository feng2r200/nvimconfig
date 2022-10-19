local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"

local function button(sc, txt, keybind, keybind_opts)
  local b = dashboard.button(sc, txt, keybind, keybind_opts)
  b.opts.hl_shortcut = "Macro"
  return b
end

local icons = require "themes.icons"

dashboard.section.header.val = {
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}
dashboard.section.buttons.val = {
  button("<leader>S.", icons.ui.SignIn .. " Load Session", ":SessionManager! load_current_dir_session<cr>"),
  button("<leader>Sf", icons.ui.Telescope .. " Find Session", "SessionManager! load_session<cr>"),
  button("<leader>fn", icons.ui.NewFile .. " New file", ":enew<cr>"),
  button("<leader>fe", icons.ui.History .. " Recent files", ':lua require("telescope.builtin").oldfiles()'),
  button(
    "<leader>fw",
    icons.ui.List .. " Find text",
    ':lua require("telescope.builtin").live_grep(require("telescope.themes").get_ivy())'
  ),
  button("<leader>Hp", icons.git.Repo .. " Find project", ":Telescope projects<cr>"),
  button(
    "<leader>ff",
    icons.documents.Files .. " Find file",
    ':lua require("telescope.builtin").find_files(require("telescope.themes").get_ivy())<cr>'
  ),
}

dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Macro"
dashboard.section.footer.opts.hl = "Type"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
