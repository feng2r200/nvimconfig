local load_core = function()
    require("gui")

    local pack = require("core.pack")

    pack.ensure_plugins()

    require("core.options")
    require("core.event")

    pack.load_compile()

    require("core.mapping")

    vim.cmd [[colorscheme edge]]
end

load_core()

