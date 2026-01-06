local colors = {
  bg = "#141414",
  fg = "#feffd3",
  cursor = "#ffffff",
  selection_bg = "#303030",
  selection_fg = "#141414",

  black = "#141414",
  black_bright = "#262626",

  red = "#c06c43",
  red_bright = "#dd7c4c",

  green = "#afb979",
  green_bright = "#cbd88c",

  yellow = "#c2a86c",
  yellow_bright = "#e1c47d",

  blue = "#444649",
  blue_bright = "#5a5d61",

  magenta = "#b4be7b",
  magenta_bright = "#d0db8e",

  cyan = "#778284",
  cyan_bright = "#8a989a",

  white = "#feffd3",
}

vim.cmd("highlight clear")
vim.o.termguicolors = true
vim.g.colors_name = "dc"

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Core UI
hi("Normal", { fg = colors.fg, bg = colors.bg })
hi("Cursor", { fg = colors.bg, bg = colors.cursor })
hi("Visual", { fg = colors.selection_fg, bg = colors.selection_bg })
hi("LineNr", { fg = colors.blue })
hi("CursorLineNr", { fg = colors.yellow_bright, bold = true })
hi("CursorLine", { bg = colors.black_bright })

hi("StatusLine", { fg = colors.fg, bg = colors.black_bright })
hi("StatusLineNC", { fg = colors.blue, bg = colors.black })

hi("Pmenu", { fg = colors.fg, bg = colors.black_bright })
hi("PmenuSel", { fg = colors.selection_fg, bg = colors.green })

hi("Search", { fg = colors.selection_fg, bg = colors.yellow })
hi("IncSearch", { fg = colors.selection_fg, bg = colors.yellow_bright })

hi("VertSplit", { fg = colors.black_bright })

-- Syntax
hi("Comment", { fg = colors.blue_bright, italic = true })
hi("String", { fg = colors.green })
hi("Number", { fg = colors.yellow })
hi("Boolean", { fg = colors.yellow_bright })
hi("Identifier", { fg = colors.fg })
hi("Function", { fg = colors.green_bright })
hi("Keyword", { fg = colors.red_bright, bold = true })
hi("Operator", { fg = colors.red })
hi("Type", { fg = colors.cyan_bright })

-- Diagnostics (LSP)
hi("DiagnosticError", { fg = colors.red })
hi("DiagnosticWarn", { fg = colors.yellow })
hi("DiagnosticInfo", { fg = colors.blue_bright })
hi("DiagnosticHint", { fg = colors.cyan })

-- Git
hi("DiffAdd", { fg = colors.green })
hi("DiffChange", { fg = colors.yellow })
hi("DiffDelete", { fg = colors.red })

-- Match & Brackets
hi("MatchParen", { fg = colors.bg, bg = colors.magenta_bright, bold = true })

-- Floating Windows
hi("NormalFloat", { fg = colors.fg, bg = colors.black_bright })
hi("FloatBorder", { fg = colors.blue_bright })

-- Telescope
hi("TelescopeBorder", { fg = colors.blue })
hi("TelescopeNormal", { fg = colors.fg, bg = colors.black })
hi("TelescopeSelection", { bg = colors.selection_bg })
