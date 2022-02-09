local load_core = function()
    require("gui")

    local pack = require("core.pack")

    pack.ensure_plugins()

    require("core.options")
    require("core.event")

    pack.load_compile()

    require("core.mapping")
end

load_core()

