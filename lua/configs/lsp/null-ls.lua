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
    diagnostics.sqlfluff.with({ extra_args = { "--ignore-local-config", "--dialect", "mysql", "--exclude-rules", "L001,L004,L006,L009,L010,L011,L016,L029,L031,L036,L059" } }),
    diagnostics.tidy,

    formatting.prettier.with {
      extra_filetypes = { "toml", "solidity" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    formatting.black.with { extra_args = { "--fast" } },
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

local unwrap = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "rust" },
  generator = {
    fn = function(params)
      local diagnostics = {}
      -- sources have access to a params object
      -- containing info about the current file and editor state
      for i, line in ipairs(params.content) do
        local col, end_col = line:find "unwrap()"
        if col and end_col then
          -- null-ls fills in undefined positions
          -- and converts source diagnostics into the required format
          table.insert(diagnostics, {
            row = i,
            col = col,
            end_col = end_col,
            source = "unwrap",
            message = "hey " .. os.getenv("USER") .. ", don't forget to handle this" ,
            severity = 2,
          })
        end
      end
      return diagnostics
    end,
  },
}

null_ls.register(unwrap)
