--[[
    Settings for mfussenegger/nvim-jdtls
--]]

vim.cmd [[set tabstop=4]]
vim.cmd [[set shiftwidth=4]]

vim.cmd [[packadd nvim-jdtls]]
vim.cmd [[packadd nvim-dap]]

local fn = vim.fn

local home_dir = os.getenv "HOME"
local std_data_dir = fn.stdpath "data"
local nvim_dir = fn.stdpath "config"

local rule_dir = nvim_dir .. "/rule/"
local java_settings_url = rule_dir .. "settings.prefs"
local java_format_style_rule = rule_dir .. "intellij-java-google-style.xml"

local java_path = {
  ["8"] = "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home",
  ["last"] = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home",
}
local executable = java_path["last"] .. "/bin/java" or "java"
local java_debug_jar = {
  fn.glob(nvim_dir .. "/pack/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
  fn.glob(nvim_dir .. "/pack/vscode-java-decompiler/server/*.jar"),
  fn.glob(nvim_dir .. "/pack/vscode-java-test/server/*.jar"),
}

local root_dir = std_data_dir .. "/mason/packages/jdtls"
local launcher_jar = fn.expand( root_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar" )
local lombok_jar = fn.expand( root_dir .. "/lombok.jar" )

local workspace_root_dir = std_data_dir .. "/eclipse/"
local project_name = fn.fnamemodify(fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_root_dir .. project_name

local get_cmd = function()
  return {
    executable,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms4g",
    "-Xmx6G",
    "-javaagent:" .. lombok_jar,
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher_jar,
    "-configuration",
    root_dir .. "/config_mac",
    "-data",
    workspace_dir,
  }
end

local lsp_handlers = require "configs.lsp.handlers"
local jdtls = require "jdtls"

local custom_attach = function(client, bufnr)
  lsp_handlers.on_attach(client, bufnr)
  jdtls.setup_dap { hotcodereplace = "auto" }
  jdtls.setup.add_commands()
end

local capabilities = lsp_handlers.capabilities

local config = {
  cmd = get_cmd(),
  root_dir = jdtls.setup.find_root { ".git", "mvnw", "gradlew", ".idea", "build.gradle" },
  settings = {
    ["java.settings.url"] = java_settings_url,
    java = {
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
          globalSettings = home_dir .. "/.m2/settings.xml",
        },
        runtimes = {
          { name = "JavaSE-1.8", path = java_path["8"], default = true },
        },
        updateBuildConfiguration = "interactive",
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = { downloadSources = true },
      foldingRange = { enabled = true },
      home = java_path["8"],
      implementationsCodeLens = { enabled = false },
      import = { maven = { enabled = true } },
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
      signatureHelp = { enabled = true },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      symbols = { includeSourceMethodDeclarations = true },
      trace = { server = "messages" },
      format = {
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
for _, jar_pattern in ipairs(java_debug_jar) do
  for _, bundle in ipairs(vim.split(jar_pattern, "\n")) do
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
vim.api.nvim_set_keymap(
  "n",
  "crv",
  "<cmd>lua require('jdtls').extract_variable()<CR>",
  { noremap = true, silent = true, desc = "Extract variable" }
)
vim.api.nvim_set_keymap(
  "v",
  "crv",
  "<cmd>lua require('jdtls').extract_variable(true)<CR>",
  { noremap = true, silent = true, desc = "Extract variable" }
)
vim.api.nvim_set_keymap(
  "n",
  "crc",
  "<cmd>lua require('jdtls').extract_constant()<CR>",
  { noremap = true, silent = true, desc = "Extract constant" }
)
vim.api.nvim_set_keymap(
  "v",
  "crc",
  "<cmd>lua require('jdtls').extract_constant(true)<CR>",
  { noremap = true, silent = true, desc = "Extract constant" }
)
vim.api.nvim_set_keymap(
  "v",
  "crm",
  "<cmd>lua require('jdtls').extract_method(true)<CR>",
  { noremap = true, silent = true, desc = "Extract method" }
)

local wk_status, wk = pcall(require, "which-key")
if wk_status then
  local mappings = {
    d = {
      r = { "<cmd>lua require('dap').continue()<CR>", "Debug run" },
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
