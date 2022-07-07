--[[
    Settings for mfussenegger/nvim-jdtls
--]]

vim.cmd [[set tabstop=4]]
vim.cmd [[set shiftwidth=4]]

vim.cmd [[packadd nvim-jdtls]]

vim.cmd [[packadd nvim-dap]]

local java_path = {
    ["8"]  = "/usr/local/Cellar/openjdk@8/1.8.0+322/libexec/openjdk.jdk/Contents/Home",
    ["11"] = "/usr/local/Cellar/openjdk@11/11.0.15/libexec/openjdk.jdk/Contents/Home",
    ["18"] = "/usr/local/Cellar/openjdk/18.0.1.1/libexec/openjdk.jdk/Contents/Home",
}

local get_cmd = function()
    local path = require "nvim-lsp-installer.core.path"
    local platform = require "nvim-lsp-installer.core.platform"
    local functional = require "nvim-lsp-installer.core.functional"

    local root_dir = path.concat {vim.fn.stdpath("data"), "lsp_servers", "jdtls"}

    local executable = path.concat { java_path["18"], "bin", "java" } or "java"
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
            functional.coalesce(
                functional.when(platform.is_mac, "config_mac"),
                functional.when(platform.is_linux, "config_linux"),
                functional.when(platform.is_win, "config_win")
            ),
        },
        "-data", path.concat { workspace_name, workspace_dir },
    }
end

local lsp_handlers = require "lsp.handlers"
local jdtls = require "jdtls"

local custom_attach = function(client, bufnr)
    lsp_handlers.on_attach(client, bufnr)
    jdtls.setup_dap({ hotcodereplace="auto" })
    jdtls.setup.add_commands()
end

local capabilities = lsp_handlers.capabilities

local config = {
    cmd = get_cmd(),
    root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', '.idea' }),
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
                    {name = "JavaSE-18", path=java_path["18"], default=true},
                },
                updateBuildConfiguration = "interactive"
            },
            contentProvider = { preferred = 'fernflower' },
            eclipse = {
              downloadSources = true,
            },
            foldingRange = { enabled = true},
            home =java_path["18"],
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

local bundles = {}
for _, jar_pattern in ipairs({
  "/pack/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
  "/pack/vscode-java-decompiler/server/*.jar",
  "/pack/vscode-java-test/server/*.jar",
}) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(vim.fn.stdpath("config") .. jar_pattern), '\n')) do
    table.insert(bundles, bundle)
  end
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
    bundles = bundles,
}

-- Setup
jdtls.start_or_attach(config)

-- command
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require('jdtls')._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require('jdtls')._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"

-- Mappings.
vim.api.nvim_set_keymap("n", "crv", "<cmd>lua require('jdtls').extract_variable()<CR>", { noremap = true, silent = true, desc = "Extract variable" })
vim.api.nvim_set_keymap("v", "crv", "<cmd>lua require('jdtls').extract_variable(true)<CR>", { noremap = true, silent = true, desc = "Extract variable" })
vim.api.nvim_set_keymap("n", "crc", "<cmd>lua require('jdtls').extract_constant()<CR>", { noremap = true, silent = true, desc = "Extract constant" })
vim.api.nvim_set_keymap("v", "crc", "<cmd>lua require('jdtls').extract_constant(true)<CR>", { noremap = true, silent = true, desc = "Extract constant" })
vim.api.nvim_set_keymap("v", "crm", "<cmd>lua require('jdtls').extract_method(true)<CR>", { noremap = true, silent = true, desc = "Extract method" })

local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    L = {
      name = "jdtls",

      d = { "<cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>", "Dap main class" },
      m = { "<cmd>lua require('jdtls').test_class()<CR>", "Test class" },
      n = { "<cmd>lua require('jdtls').test_nearest_method()<CR>", "Test nearest method" },
    },
  }

  wk.register(mappings, {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  })
end

