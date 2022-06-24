local status_ok, icons = pcall(require, "nvim-web-devicons")
if not status_ok then
  return
end

icons.set_icon({
  deb = { icon = "", name = "Deb" },
  lock = { icon = "", name = "Lock" },
  mp3 = { icon = "", name = "Mp3" },
  mp4 = { icon = "", name = "Mp4" },
  out = { icon = "", name = "Out" },
  ["robots.txt"] = { icon = "ﮧ", name = "Robots" },
  ttf = { icon = "", name = "TrueTypeFont" },
  rpm = { icon = "", name = "Rpm" },
  woff = { icon = "", name = "WebOpenFontFormat" },
  woff2 = { icon = "", name = "WebOpenFontFormat2" },
  xz = { icon = "", name = "Xz" },
  zip = { icon = "", name = "Zip" },
})

