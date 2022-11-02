local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
  debug = false,
  sources = {
    diagnostics.jsonlint,
    diagnostics.sqlfluff.with {
      extra_args = {
        "--ignore-local-config",
        "--dialect",
        "mysql",
        "--exclude-rules",
        "L001,L004,L006,L009,L010,L011,L016,L029,L031,L036,L059",
      },
    },
    diagnostics.tidy,

    formatting.rustfmt.with {
      extra_args = function(params)
        local Path = require "plenary.path"
        local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

        if cargo_toml:exists() and cargo_toml:is_file() then
          for _, line in ipairs(cargo_toml:readlines()) do
            local edition = line:match [[^edition%s*=%s*%"(%d+)%"]]
            if edition then
              return { "--edition=" .. edition }
            end
          end
        end
        -- default edition when we don't find `Cargo.toml` or the `edition` in it.
        return { "--edition=2021" }
      end,
    },

    formatting.gofmt,

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
      extra_args = { "--config-path", vim.fn.expand(vim.fn.stdpath "config" .. "/.stylua.toml") },
    },
    formatting.shfmt,
  },
}

