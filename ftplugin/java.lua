--[[
    Settings for mfussenegger/nvim-jdtls
--]]

local get_cmd = function()
    local path = require "nvim-lsp-installer.path"
    local platform = require "nvim-lsp-installer.platform"
    local Data = require "nvim-lsp-installer.data"

    local root_dir = path.concat {vim.fn.stdpath("data"), "lsp_servers", "jdtls"}

    local executable = vim.env.JAVA_HOME and path.concat { vim.env.JAVA_HOME, "bin", "java" } or "java"
    local jar = vim.fn.expand(path.concat { root_dir, "plugins", "org.eclipse.equinox.launcher_*.jar" })
    local lombok = vim.fn.expand(path.concat { root_dir, "lombok.jar" })
    local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_name = path.concat {vim.fn.stdpath("data"), "eclipse"}

    return {
        platform.is_win and ("%s.exe"):format(executable) or executable,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms2g",
        "-Xmx4G",
        "-javaagent:" .. lombok,
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", jar,
        "-configuration",
        path.concat {
            root_dir,
            Data.coalesce(
                Data.when(platform.is_mac, "config_mac"),
                Data.when(platform.is_linux, "config_linux"),
                Data.when(platform.is_win, "config_win")
            ),
        },
        "-data", path.concat { workspace_name, workspace_dir },
    }
end

local config = {
    cmd = get_cmd(),
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
    settings = {
        java = {
        }
    },
    init_options = {
        bundles = {}
    },
}

require("jdtls").start_or_attach(config)
