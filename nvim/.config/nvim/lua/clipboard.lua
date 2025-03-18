local globals = require 'globals'

if globals.is_mac then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
  }
elseif globals.is_wsl then
  vim.g.clipboard = {
    name = "psyank-wsl",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = [[powershell.exe -NoProfile -NoLogo -NonInteractive -MTA -Command [console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
      ["*"] = [[powershell.exe -NoProfile -NoLogo -NonInteractive -MTA -Command [console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
    },
    cache_enabled = 0,
  }
end

