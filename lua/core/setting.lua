local api = require("utils.api")

----------------------
require("conf.config")
require("conf.preference")
----------------------

local M = {}

function M.get_icon_groups(groups_name, has_suffix_space)
    local icon = vim.deepcopy(api.get_config()["icon"][groups_name])

    if has_suffix_space then
        for name, font in pairs(icon) do
            icon[name] = ("%s "):format(font)
        end
    end

    return icon
end

----------------------

function M.get_depend_base_path()
    return api.path.join("core", "depends")
end

function M.get_mason_install_path()
    return api.path.join(vim.fn.stdpath("data"), "mason")
end

function M.get_depends_install_path()
    return api.path.join(vim.fn.stdpath("data"), "lazy")
end

return M
