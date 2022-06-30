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
    diagnostics.sqlfluff.with({ extra_args = { "--ignore-local-config", "--dialect", "mysql", "--exclude-rules", "L029,L016" } }),
    diagnostics.tidy,

    formatting.prettier.with {
      extra_filetypes = { "toml", "solidity" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    formatting.google_java_format,
    formatting.black,
    formatting.jq,
    formatting.sqlfluff.with({ extra_args = { "--dialect", "mysql", "--FIX-EVEN-UNPARSABLE" } }),

    code_actions.gitsigns,
  },
}
