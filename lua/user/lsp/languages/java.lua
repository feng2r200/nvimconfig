--[[
    Settings for mfussenegger/nvim-jdtls
--]]

local M = {}

vim.cmd [[packadd nvim-jdtls]]
vim.cmd [[packadd nvim-dap]]

local fn = vim.fn

local env = {
  HOME = os.getenv "HOME",
  DATA_DIR = fn.stdpath "data",
  NVIM_DIR = fn.stdpath "config",
}

local maven_settings = env.HOME .. "/.m2/settings.xml"

local rule_dir = env.NVIM_DIR .. "/rule/"
local java_settings_url = rule_dir .. "settings.prefs"
local java_format_style_rule = rule_dir .. "intellij-java-google-style.xml"

local java_path = {
  ["8"] = "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home",
  ["17"] = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
  ["last"] = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home",
}
local executable = java_path["17"] .. "/bin/java" or "java"

local vscode = require("user.utils.vscode")
local java_vscode_jar = {}
local vscode_java_debug_path = vscode.find_one("/vscjava.vscode-java-debug-*/server")
if vscode_java_debug_path then
  table.insert(java_vscode_jar, fn.glob(vscode_java_debug_path .. "/com.microsoft.java.debug.plugin-*.jar"))
end

local vscode_java_test_path = vscode.find_one("/vscjava.vscode-java-test-*/server")
if vscode_java_test_path then
  table.insert(java_vscode_jar, fn.glob(vscode_java_test_path .. "/*.jar"))
end

local java_decompiler_path = vscode.find_one("/dgileadi.java-decompiler-*/server")
if java_decompiler_path then
  table.insert(java_vscode_jar, fn.glob(java_decompiler_path .. "/*.jar"))
end

local java_dependency_path = vscode.find_one("/vscjava.vscode-java-dependency-*/server")
if java_dependency_path then
  table.insert(java_vscode_jar, fn.glob(java_dependency_path .. "/*.jar"))
end

local jdtls_dir = env.DATA_DIR .. "/mason/packages/jdtls"
local jdtls_launcher = fn.expand( jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar" )
local lombok_jar = fn.expand( jdtls_dir .. "/lombok.jar" )

local workspace_root_dir = env.DATA_DIR .. "/eclipse/"
local project_name = fn.fnamemodify(fn.getcwd(), ":p:h:gs?/?%?")
local workspace_dir = workspace_root_dir .. project_name

local get_cmd = function()
  return {
    executable,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dsun.zip.disableMemoryMapping=true",
    "-XX:+UseG1GC",
    "-XX:MaxGCPauseMillis=200",
    "-XX:InitiatingHeapOccupancyPercent=45",
    "-Xms1g",
    "-Xmx2G",
    "-XX:ReservedCodeCacheSize=1024m",
    "-XX:NewRatio=4",
    "-XX:SurvivorRatio=16",
    "-XX:MaxTenuringThreshold=15",
    "-XX:G1ReservePercent=10",
    "-Xss16m",
    "-XX:ConcGCThreads=4",
    "-XX:+AlwaysPreTouch",
    "-XX:+TieredCompilation",
    "-XX:MaxJavaStackTraceDepth=10000",
    "-XX:SoftRefLRUPolicyMSPerMB=100",
    "-javaagent:" .. lombok_jar,
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    jdtls_launcher,
    "-configuration",
    jdtls_dir .. "/config_mac",
    "-data",
    workspace_dir,
  }
end

local lsp_handlers = require "user.lsp.handlers"
local jdtls = require "jdtls"

local custom_attach = function(client, bufnr)
  lsp_handlers.on_attach(client, bufnr)
  jdtls.setup_dap { hotcodereplace = "auto" }
  jdtls.setup.add_commands()
end

local capabilities = lsp_handlers.capabilities

local config = {
  cmd = get_cmd(),
  filetypes = { "java" },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", ".idea", "build.gradle", "pom.xml" }),
  settings = {
    ["java.settings.url"] = java_settings_url,
    java = {
      templates = {
        fileHeader = {
          "/**",
          " * @author: ${user}",
          " * @date: ${date}",
          " * @description: ${file_name}",
          " */",
        },
        typeComment = {
          "/**",
          " * @description: ${type_name}",
          " */",
        },
      },
      maxConcurrentBuilds = 8,
      project = {
        encoding = "UTF-8",
        resourceFilters = {
          "node_modules",
          ".git",
          ".idea",
        },
      },
      server = {
        launchMode = "Hybrid",
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
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
          userSettings = maven_settings,
          globalSettings = maven_settings,
        },
        runtimes = {
          { name = "JavaSE-1.8", path = java_path["8"], default = true },
          { name = "JavaSE-17", path = java_path["17"] },
        },
        updateBuildConfiguration = "interactive",
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = { downloadSources = true },
      foldingRange = { enabled = true },
      home = java_path["8"],
      implementationsCodeLens = { enabled = false },
      import = {
        maven = { enabled = true },
        exclusions = {
          "**/node_modules/**",
          "**/.metadata/**",
          "**/archetype-resources/**",
          "**/META-INF/maven/**",
          "**/.git/**",
          "**/.idea/**",
        },
      },
      maven = {
        downloadSources = true,
        updateSnapshots = true,
      },
      referencesCodeLens = { enabled = false },
      references = {
        includeAccessors = true,
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      rename = { enabled = true },
      selectionRange = { enabled = true },
      signatureHelp = {
        enabled = true,
        description = {
          enabled = true,
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      symbols = { includeSourceMethodDeclarations = true },
      trace = { server = "messages" },
      format = {
        enabled = true,
        settings = {
          url = java_format_style_rule,
          profile = "GoogleStyle",
        },
      },
    },
  },
  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
    server_side_fuzzy_completion = true
  },
  capabilities = capabilities,
  on_attach = custom_attach,
}

config.on_init = function(client, _)
  client.notify("workspace/didChangeConfiguration", { settings = config.settings })
end

local bundles = {}
for _, jar_pattern in ipairs(java_vscode_jar) do
  for _, bundle in ipairs(vim.split(jar_pattern, "\n")) do
    table.insert(bundles, bundle)
  end
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.progressReportProvider = false

config.init_options = {
  extendedClientCapabilities = extendedClientCapabilities,
  bundles = bundles,
}

config.handlers = {}
config.handlers["language/status"] = function(_, s)
  if "ServiceReady" == s.type then
    require("jdtls.dap").setup_dap_main_class_configs({ verbose = true })
  end
end

vim.lsp.handlers["$/progress"] = nil
require("fidget").setup({})

-- Setup
M.init = function ()
  vim.g.jdtls_dap_main_class_config_init = true

  vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
    pattern = "jdt://*",
    callback = function(e)
      require("jdtls").open_classfile(e.file)
    end,
  })

  vim.api.nvim_create_user_command("JdtWipeDataAndRestart", "lua require('jdtls.setup').wipe_data_and_restart()", {})
  vim.api.nvim_create_user_command("JdtShowLogs", "lua require('jdtls.setup').show_logs()", {})

  -- command
  vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require('jdtls')._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require('jdtls')._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
  vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
  vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"

  local group = vim.api.nvim_create_augroup("nvim_jdtls_java", { clear = true })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = { "java" },
    desc = "jdtls",
    callback = function(e)
      if e.file == "java" then
        -- ignore
      else
        jdtls.start_or_attach(config)
      end
    end,
  })
  return group
end

return M
