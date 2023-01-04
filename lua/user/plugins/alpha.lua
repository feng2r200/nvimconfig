local M = {
    "goolord/alpha-nvim",
    requires = {
        "kyazdani42/nvim-web-devicons",
    },
}

M.config = function()
    require("user.plugins.alpha.alpha")
end

return M