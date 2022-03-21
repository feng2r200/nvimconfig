require("gui")

local pack = require("core.pack")
pack.ensure_plugins()

require("core.options")
require("core.autocmds")

pack.load_compile()

require("core.mappings")

