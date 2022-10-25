vim.g.sql_type_default = "mysql"
return {
  cmd = { "sqls", "-config", os.getenv("HOME") .. "/.config/sqls/config.yml" },
  on_attach = function (client, bufnr)
    require("sqls").on_attach(client, bufnr)
  end
}
