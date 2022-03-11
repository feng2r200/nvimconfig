local load_core = function()
    require("gui")

    local pack = require("core.pack")
    pack.ensure_plugins()

    require("core.options")
    require("core.autocmds")

    pack.load_compile()

    require("core.mappings")
end

load_core()

