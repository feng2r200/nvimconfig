local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
  return
end

gps.setup({
  icons = {
    ["class-name"] = " ", -- Classes and class-like objects
    ["function-name"] = " ", -- Functions
    ["method-name"] = " ", -- Methods (functions inside class-like objects)
    ["container-name"] = '⦿ ',
    ["tag-name"] = '# '
  },
  separator = " > "
})
