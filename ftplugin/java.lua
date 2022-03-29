--[[
    Settings for mfussenegger/nvim-jdtls
--]]

local java_path = {
    ["8"] = "/usr/local/Cellar/openjdk@8/1.8.0+322/libexec/openjdk.jdk/Contents/Home",
    ["11"]= "/usr/local/Cellar/openjdk@11/11.0.14.1/libexec/openjdk.jdk/Contents/Home",
    ["17"]= "/usr/local/Cellar/openjdk/17.0.2/libexec/openjdk.jdk/Contents/Home",
}

local get_cmd = function()
    local path = require "nvim-lsp-installer.path"
    local platform = require "nvim-lsp-installer.platform"
    local Data = require "nvim-lsp-installer.data"

    local root_dir = path.concat {vim.fn.stdpath("data"), "lsp_servers", "jdtls"}

    local executable = path.concat { java_path["11"], "bin", "java" } or "java"
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
        "-Xms4g",
        "-Xmx6G",
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

local custom_attach = function(client, bufnr)
    require("modules.completion.lsp").custom_attach(client, bufnr)
    require("jdtls.setup").add_commands()
    require("jdtls").setup_dap({hotcodereplace="auto"})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local config = {
    cmd = get_cmd(),
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', "pom.xml"}),
    settings = {
        java = {
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                hashCodeEquals = {
                    useInstanceof = true,
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            completion = { enabled = false },
            configuration = {
                maven = {
                    globalSettings = os.getenv("HOME") .. "/.m2/settings.xml",
                },
                runtimes = {
                    {name = "JavaSE-1.8", path=java_path["8"], default=true},
                    {name = "JavaSE-11", path=java_path["11"]},
                    {name = "JavaSE-17", path=java_path["17"]},
                },
                updateBuildConfiguration = "interactive"
            },
            contentProvider = { preferred = 'fernflower' },
            foldingRange = { enabled = true},
            home =java_path["11"],
            implementationsCodeLens = { enabled = true },
            import = {
                maven = { enabled = true },
            },
            maven = {
                downloadSources = true,
                updateSnapshots = true,
            },
            referencesCodeLens = { enabled = true },
            references = {
                includeAccessors = true,
                includeDecompiledSources = true,
            },
            rename = { enabled = true },
            selectionRange = { enabled = true },
            signatureHelp = { enabled = true },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            symbols = {
                includeSourceMethodDeclarations = true,
            },
            trace = {
                server = "messages"
            }
        }
    },
    flags = {
        allow_incremental_sync = true,
    },
    capabilities = capabilities,
    on_attach = custom_attach,
}

config.on_init = function(client, _)
    client.notify("workspace/didChangeConfiguration", { settings = config.settings})
end

local bundles = {
    vim.fn.glob(os.getenv("XDG_CONFIG_HOME") .. "/nvim/java-debug/com.microsoft.java.debug.plugin-*.jar"),
};
vim.list_extend(bundles, vim.split(vim.fn.glob(os.getenv("XDG_CONFIG_HOME") .. "/nvim/vscode-java-test/*.jar"), "\n"))
vim.list_extend(bundles, vim.split(vim.fn.glob(os.getenv("XDG_CONFIG_HOME") .. "/nvim/vscode-java-decompiler/*.jar"), "\n"))

local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
    bundles = bundles,
}

-- Mappings.
vim.api.nvim_set_keymap("n", "crv", ":lua require('jdtls').extract_variable()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "crv", ":<Esc>lua require('jdtls').extract_variable(true)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "crc", ":lua require('jdtls').extract_constant()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "crc", ":<Esc>lua require('jdtls').extract_constant(true)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "crm", ":<Esc>lua require('jdtls').extract_method(true)<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>dn", ":lua require('jdtls').test_nearest_method()<CR>", { noremap = true, silent = true })

-- command
vim.cmd [[ command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config() ]]

-- Setup
require("jdtls").start_or_attach(config)
