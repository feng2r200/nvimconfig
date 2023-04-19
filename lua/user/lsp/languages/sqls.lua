return {
  cmd = { "sql-language-server", "up", "--method", "stdio" },
  filetypes = { "sql", "mysql" },
  root_dir = function()
    return os.getenv("HOME") .. "/.config/sql-language-server/"
  end
}
