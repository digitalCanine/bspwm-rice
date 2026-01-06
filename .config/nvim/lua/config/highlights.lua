-- Force LazyVim UI elements to use Carrie's green 🐾🌿

local green = "#afb979"
local green_bright = "#cbd88c"
local bg = "#141414"

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ✅ WhichKey menu (the big popup cheat sheet)
hi("WhichKey", { fg = green_bright })
hi("WhichKeyGroup", { fg = green })
hi("WhichKeyDesc", { fg = green_bright })
hi("WhichKeyBorder", { fg = green })

-- ✅ Lazy.nvim plugin manager UI
hi("LazyNormal", { bg = bg })
hi("LazyButton", { fg = green })
hi("LazyButtonActive", { fg = bg, bg = green_bright, bold = true })
hi("LazyH1", { fg = green_bright, bold = true })

-- ✅ Completion menu (nvim-cmp)
hi("CmpItemAbbr", { fg = green_bright })
hi("CmpItemAbbrMatch", { fg = green, bold = true })
hi("CmpBorder", { fg = green })
hi("CmpNormal", { bg = bg })

-- ✅ Telescope menus (if you use it)
hi("TelescopeBorder", { fg = green })
hi("TelescopePromptBorder", { fg = green })
hi("TelescopeSelection", { bg = "#303030" })
hi("TelescopePromptPrefix", { fg = green_bright })

-- ✅ Floating menus in general
hi("FloatBorder", { fg = green })
