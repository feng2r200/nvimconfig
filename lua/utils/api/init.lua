local M = {}

function M.get_config()
    return require("conf.config")
end

function M.get_setting()
    return require("core.setting")
end

function M.get_lang()
    return require("core.package.simple-lang")
end

M.fn = require("utils.api.fn")
M.lsp = require("utils.api.lsp")
M.map = require("utils.api.map")
M.path = require("utils.api.path")

return M

