local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local formatting   = null_ls.builtins.formatting
local diagnostics  = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,
  sources = {
    diagnostics.jsonlint,
    diagnostics.sqlfluff.with({ extra_args = { "--ignore-local-config", "--dialect", "mysql", "--exclude-rules", "L001,L004,L009,L010,L016,L029,L031,L036" } }),
    diagnostics.tidy,

    formatting.prettier.with {
      extra_filetypes = { "toml", "solidity" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    formatting.google_java_format,
    formatting.black,
    formatting.jq,
    formatting.tidy.with {
      extra_args = { "-xml", "-i" },
    },
    formatting.sqlfluff.with {
      extra_args = { "--dialect", "mysql", "--FIX-EVEN-UNPARSABLE" },
    },
    formatting.stylua.with {
      extra_args = { "--config-path", vim.fn.expand( vim.fn.stdpath "config" .. "/.stylua.toml" ) },
    },

    code_actions.gitsigns,
  },
}
