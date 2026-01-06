-- Neo-tree toggle with `
vim.keymap.set("n", "`", function()
  vim.cmd("Neotree toggle right")
end, { desc = "Toggle Neo-tree" })

-- Buffer (tab/page) navigation
vim.keymap.set("n", "[", vim.cmd.bprevious, { desc = "Previous buffer" })
vim.keymap.set("n", "]", vim.cmd.bnext, { desc = "Next buffer" })
