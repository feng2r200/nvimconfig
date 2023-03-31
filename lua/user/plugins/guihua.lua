local M = { "ray-x/guihua.lua", run = "cd lua/fzy && make" }

M.config = function()
  require('guihua.maps').setup()
end

return M
